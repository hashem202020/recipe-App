//
//  ViewController.swift
//  iosTask
//
//  Created by apple on 8/4/21.
//

import UIKit
import RxSwift
import RxCocoa

class searchVC: UIViewController {

    @IBOutlet weak var searchTextView: UIView!
    @IBOutlet weak var filtersCollection: UICollectionView!
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var noResultsImage: UIImageView!
    @IBOutlet weak var noResultView: UIView!
    
    
    var filters = ["All", "Low Sugar", "Keto" , "Vegan"]
    var selectedCollectionCell : Int?
    
    var from = 0
    var to = 0
    
    var q = "All"
    var health = ""
    
    let searchViewModel = SearchViewModel()
    let disposeBag = DisposeBag()
            
    override func viewDidLoad() {
        super.viewDidLoad()

        uiHandler()
        subscribeToLoading()
        subscribeToNetworkError()
        bindParamsToViewModel(q: q, health: health)
        getRecipes()
        subscribeTableViewState()
        subscribeToResponse()
        subscribeCellSelection()
        
    }
    
 
    //MARK:- UIHandler
    /// this function handles the UI Items
    func uiHandler(){
        title = recipeSearchVCTitle
        
        searchTextView.layer.borderWidth = 1
        searchTextView.layer.borderColor = UIColor.lightGray.cgColor
        searchTextView.layer.cornerRadius = 12
        
        filtersCollection.register(UINib(nibName: filterCollectionCellName, bundle: nil), forCellWithReuseIdentifier: filterCollectionCellName)
        recipesTableView.register(UINib(nibName: searchTableCellName, bundle: nil), forCellReuseIdentifier: searchTableCellName )
        
        recipesTableView.rx.setDelegate(self).disposed(by: disposeBag)

        
        recipesTableView.layoutIfNeeded()
    }
    
    
    //MARK: filters handler
    /// this function handles the api keys of the filters ..the appeard names of the filters is not the keys of the api
    /// - Parameter value: the filter name
    func filtersHandelr(value: String){
        switch value {
        case "Low Sugar":
            health = lowSugarFilter
        
        case "Keto":
            health = ketoFriendlyFilter
            
        case "Vegan":
            health = veganFilter
            
        default:
            health = ""
        }
    }
    
    
    //MARK:- Loading control Binding
    /// show and hide spinner
    func subscribeToLoading(){
        searchViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showSpinner()
            }else{
                self.removeSpinner()
            }
        }).disposed(by: disposeBag)
    }
    
    
    //MARK:- isTableHidden Binding
    /// show and hide tableview
    func subscribeTableViewState(){
        
        searchViewModel.isTableHiddenBehavior.subscribe(onNext: { (isHidden) in
            self.recipesTableView.isHidden = isHidden
            self.noResultView.isHidden = !isHidden

            }).disposed(by: disposeBag)
    }
    
    //MARK:- Network error Binding
    /// get the network error if exist
    func subscribeToNetworkError(){
        searchViewModel.networkErrorBehavior.subscribe(onNext: { (error) in
            if error != ""{
            self.createWarning(message: error)
            }
        }).disposed(by: disposeBag)
    }
    
    
    //MARK:- bind Parameters To ViewModel
    /// passing the q & health to the ViewModel
    func bindParamsToViewModel(q: String, health: String){
        searchViewModel.qBehavior.accept(q)
        searchViewModel.healthBehavior.accept(health)
        }
    
    
    //MARK:- GetRecipes
    /// this function getting data from API
    func getRecipes(){
        searchViewModel.getRecipes(page: from, isSperatePage: false)
    }
    
    
    //MARK:- response subscription
    /// subscribing data from Response
    func subscribeToResponse(){
        //subscribing the general data to handle the pagination
        self.searchViewModel.recipeObservable.subscribe { (recipeModel: RecipeModel?) in
            self.to = recipeModel?.to ?? 0
        }.disposed(by: disposeBag)

        //subscribing the detailed data
        self.searchViewModel.recipeDataModelObservable.bind(to:self.recipesTableView.rx.items(cellIdentifier: searchTableCellName, cellType: searchTableCell.self)){row, hits, cell in
            
            cell.recipeImg.loadImage(URL(string: hits.recipe?.image ?? ""))
            cell.titleLabel.text = hits.recipe?.label
            cell.sourceLabel.text = hits.recipe?.source
            cell.healthLabels = hits.recipe?.healthLabels ?? []

            cell.healthLabelsCollection.reloadData()
                        
        }.disposed(by: disposeBag)
    }
    
    //MARK:- subscribe to cell selection
    /// subscripe when press on the result to show it's Details
    func subscribeCellSelection(){
        Observable.zip(recipesTableView.rx.itemSelected,recipesTableView.rx.modelSelected(RecipeModel.Hits.self)).bind{
            [unowned self] indexpath, model in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: recipeDetailsVCName) as? recipeDetails{
                vc.imgURL = model.recipe?.image
                vc.recipeName = model.recipe?.label
                vc.ingredientLines = model.recipe?.ingredientLines ?? []
                vc.recipeURL = model.recipe?.url
                vc.title = model.recipe?.label
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }.disposed(by: disposeBag)
        
    }
    
    
    //MARK:-Paginator
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
          let contentYoffset = scrollView.contentOffset.y
          let distanceFromBottom = scrollView.contentSize.height - contentYoffset
          if distanceFromBottom <= height {
            if (self.to) > (self.from) {
                self.from+=1
                self.searchViewModel.getRecipes(page: self.from, isSperatePage: true)
            }
          }
      }
    
    
    
    //MARK:- subscribe search word
    /// subscripe when write word on the search bar at the second VC
    /// - Parameter vc: the presented suggestions VC
    func subscribeSearchWord(vc: suggestionsVC){
        vc.qBehavior.subscribe{
            [weak self] (result) in
                guard let self = self else {return}
            guard let value = result.element else {return}
            self.q = (value == "") ? self.q : value
            self.bindParamsToViewModel(q: self.q, health: self.health)
            self.getRecipes()
            
        }.disposed(by: disposeBag)
    }
    
    
    //MARK:- search button
    @IBAction func searchPressed(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: suggestionVCName) as? suggestionsVC{
            subscribeSearchWord(vc: vc)
            present(vc, animated: true, completion: nil)
        }
    }

}

//MARK:- filters Collection Config

extension searchVC: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCollectionCellName, for: indexPath) as! filterCollectionCell
        
        if selectedCollectionCell == indexPath.row{
            cell.cellView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.filterLabel.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            cell.cellView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.filterLabel.tintColor = #colorLiteral(red: 0.666592598, green: 0.6667093039, blue: 0.666585207, alpha: 1)
        }
        cell.filterLabel.text = filters[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        return CGSize(width: bounds.size.width / 3, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCollectionCell = indexPath.row
        filtersHandelr(value: filters[indexPath.row])
        from = 0
        bindParamsToViewModel(q: q, health: health)
        getRecipes()
        filtersCollection.reloadData()
    }
}

