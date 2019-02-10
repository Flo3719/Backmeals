//
//  AddCupboardItemViewController.swift
//  Backpacker Food
//
//  Created by Florian Fahrenholz on 19.01.19.
//  Copyright © 2019 Florian Fahrenholz. All rights reserved.
//

import UIKit
import NotificationCenter

var commonIngredients: [String] = []

var SuggestionButtonVar: String = ""



class AddCupboardItemViewController: UIViewController{
    
    //SUGGESTIONS button outlet
    @IBOutlet weak var SuggestionButtonOutlet: UIButton!
    
    //Textfield
    @IBOutlet weak var AddItemTextfield: UITextField!
    
    //Suggestions Button Action
    @IBAction func SuggestionButtonAction(_ sender: Any) {
        if(SuggestionButtonOutlet.titleLabel!.text != ""){
        AddItemTextfield.text = SuggestionButtonVar
        AddCupboardItem(self)
        }
    }
    
    
    @IBAction func AddCupboardItem(_ sender: Any) {
        
        if(AddItemTextfield.text != ""){
        
            let itemsObject = UserDefaults.standard.object(forKey: "BackpackItems")
            
            var items:[String]
            
            if let tempItems = itemsObject as? [String]{
                
                items = tempItems
                
                items.append(AddItemTextfield.text!)
                
                //print(items)
            }
            else
            {
                
                items = [AddItemTextfield.text!]
                
                //print(items)
                
            }
            
            UserDefaults.standard.set(items, forKey: "BackpackItems")
            
            //Try to add ingredient to common Ingredients
            
            addToCommonIngredients(Ingredient: AddItemTextfield.text!)
            
            UserDefaults.standard.set(commonIngredients, forKey: "commonIngredients")
            
            print(commonIngredients)

            //Reset form and vars
            
            AddItemTextfield.text = ""
            
            SuggestionButtonVar = ""
            
            SuggestionButtonOutlet.setTitle("", for: .normal)
            
        }else{
            showAlert(title: "oops!", message: "You haven't typed anything.")
        }
        
    }
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
//    }
    
//    @objc func keyboardWillShow(notification: NSNotification){
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let keyboardHeight = keyboardSize.height
//            print(keyboardHeight)
//
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        AddItemTextfield.becomeFirstResponder()
        
        commonIngredients = LoadCommongIngredients()
        
    }
    
    func LoadCommongIngredients() -> [String]{
        if(UserDefaults.standard.object(forKey: "commonIngredients") != nil ){
            commonIngredients = UserDefaults.standard.object(forKey: "commonIngredients") as! [String]
        }
        else{
            commonIngredients = []
        }
        return commonIngredients
    }
    

        
    
    //Textfield Text changed
    @IBAction func IngredientTextChanged(_ sender: UITextField) {
        if(AddItemTextfield.text != ""){
            makeSuggestions(InputSoFar: AddItemTextfield.text ?? "")
        }
        else{
            SuggestionButtonOutlet.setTitle("", for: .normal)
            SuggestionButtonVar = ""
        }
    }

    
    func makeSuggestions(InputSoFar: String){
        //print("called MakeSuggestions")
        
        
        let matchingTerms = commonIngredients.filter({
            $0.range(of: InputSoFar, options: .caseInsensitive) != nil
        })
        
        if(matchingTerms != []){
            if(AddItemTextfield.isEditing){
                SuggestionButtonOutlet.setTitle(matchingTerms[0], for: .normal)
                SuggestionButtonVar = matchingTerms[0]

            }
        }
        else{
            SuggestionButtonOutlet.setTitle("", for: .normal)
            SuggestionButtonVar = ""
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addToCommonIngredients(Ingredient: String){
        if(!commonIngredients.contains(Ingredient)){
            commonIngredients.append(Ingredient)
        }
    }


}
