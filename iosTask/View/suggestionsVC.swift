//
//  suggestionsVC.swift
//  iosTask
//
//  Created by apple on 8/4/21.
//

import UIKit
import RxCocoa
import RxSwift
import NaturalLanguage
import MOLH

class suggestionsVC: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var suggestionsTableView: UITableView!
   
    
    var suggestionsArr: [String] = []
    
    var searchViewModel = SearchViewModel()
    
    var qBehavior = BehaviorRelay<String>(value: "")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiHandeler()
        
    }
    
    //MARK:- Ui Handler
    func uiHandeler(){
        searchTextField.becomeFirstResponder()
        searchTextField.delegate = self
        

        suggestionsTableView.register(UINib(nibName: suggestionCellName, bundle: nil), forCellReuseIdentifier: suggestionCellName)
        
        suggestionsArr = UserDefaults.standard.value(forKey: suggestionArrayKey) as? [String] ?? []
        suggestionsArr.reverse()
        print(suggestionsArr)
        
        suggestionsTableView.reloadData()
        
    }
    
    //MARK:- text changing
    @IBAction func searchTextFieldEditing(_ sender: UITextField) {
        if sender.text?.first == " " || sender.text?.isEnglish() == false{
             sender.text?.removeAll()
         }
        
    }
    
    
    //MARK:- clear button
    @IBAction func clearButtonPressed(_ sender: Any) {
        suggestionsArr = []
        UserDefaults.standard.setValue(suggestionsArr, forKey: suggestionArrayKey)
        suggestionsTableView.reloadData()
    }
    
    

    //MARK:- Cancel button
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- suggestion handling
    /// this function handling the suggestions cases
    /// - Parameter suggestion: the new suggestion to be add it's a string
    func suggestionsHandling(suggestion: String){
        
        if suggestionsArr.count == 0 {
            suggestionsArr.append(suggestion)
        }else if suggestionsArr.count == 10 {
            suggestionsArr.removeFirst()
            suggestionsArr.append(suggestion)
        }else{
            suggestionsArr.append(suggestion)
        }
        UserDefaults.standard.setValue(suggestionsArr, forKey: suggestionArrayKey)

    }
    
}



//MARK:- Textfield Delegate
extension suggestionsVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if searchTextField.text?.isEnglish() != false{
            suggestionsHandling(suggestion: searchTextField.text ?? "")
            
            dismiss(animated: true) {
                self.qBehavior.accept(self.searchTextField.text ?? "")
            }
        }
        return false
    }
    
}

//MARK:- tableView Config
extension suggestionsVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestionsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: suggestionCellName) as! suggestionsTableCell
        cell.suggestionLabel.text = suggestionsArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.text = suggestionsArr[indexPath.row]
    }
    
}


