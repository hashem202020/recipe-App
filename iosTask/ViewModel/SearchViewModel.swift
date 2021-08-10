//
//  searchViewModel.swift
//  iosTask
//
//  Created by hashem on 06/08/2021.
//

import Foundation
import RxCocoa
import RxSwift


class SearchViewModel{
    
    let disposeBag = DisposeBag()
    
    //listen to the user q={search word} and health filter
    var qBehavior = BehaviorRelay<String>(value: "All")
    var healthBehavior = BehaviorRelay<String>(value: "")
    
    //Listen to the loading behavior
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    //Listen to the network error
    var networkErrorBehavior = BehaviorRelay<String>(value: "")
    
    //listen to the state of the tableview
    var isTableHiddenBehavior = BehaviorRelay<Bool>(value: false)
    
    
    //Encapsulation recipe data details
    private var recipeDataModelSubject = PublishSubject<[RecipeModel.Hits]>()
    
    var recipeDataModelObservable: Observable<[RecipeModel.Hits]>{
        return recipeDataModelSubject
    }

    //Encapsulation recipe GeneralData
    private var recipeSubject = PublishSubject<RecipeModel>()
    
    var recipeObservable: Observable<RecipeModel>{
        return recipeSubject
    }
        
    private var hits: [RecipeModel.Hits]?
    
    var url : String?
    
    //&q=\(qBehavior.value)
    //&health=\(healthBehavior)
    //MARK:- Get CurrentOrders Data
    func getRecipes(page: Int , isSperatePage: Bool){
        
        if healthBehavior.value == ""{
            url = "\(baseURL)&q=\(qBehavior.value)&from=\(page)"
        }else{
            url = "\(baseURL)&q=\(qBehavior.value)&health=\(healthBehavior.value)&from=\(page)"
        }
        
        loadingBehavior.accept(true)
        APIService.sharedInstance.getData(url: url ?? "", method: .get, param: nil) { [weak self] (recipeModel: RecipeModel?, error) in
            guard let self = self else {return}

            self.loadingBehavior.accept(false)

            if let error = error{
                self.networkErrorBehavior.accept(error.localizedDescription)
                
            }else{
                guard let recipeModel = recipeModel else {return}
                
                if recipeModel.more == false{
                    self.isTableHiddenBehavior.accept(true)
                }else{
                    self.isTableHiddenBehavior.accept(false)

                }
                
                if (!isSperatePage){
                    self.hits = recipeModel.hits
                    self.recipeDataModelSubject.onNext(recipeModel.hits ?? [])

                }else{
                    for hits in recipeModel.hits ?? [] {
                        self.hits?.append(hits)
                    }
                    self.recipeDataModelSubject.onNext(self.hits ?? [])
                }
                self.recipeSubject.onNext(recipeModel)
            }
        }
    }
    
}
