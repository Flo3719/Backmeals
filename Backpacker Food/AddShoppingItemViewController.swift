//
//  AddShoppingItemViewController.swift
//  Backpacker Food
//
//  Created by Florian Fahrenholz on 22.01.19.
//  Copyright © 2019 Florian Fahrenholz. All rights reserved.
//

import UIKit



class AddShoppingItemViewController: UIViewController {
    
    
    
    var commonIngredients: [String] = []
    
    var SuggestionButtonVar: String = ""
    
    
    @IBOutlet weak var SuggestionButtonOutlet: UIButton!
    
    
    @IBOutlet weak var AddShoppingField: UITextField!
    
    //Suggestions Button Action
    @IBAction func SuggestionButtonAction(_ sender: Any) {
        if(SuggestionButtonOutlet.titleLabel!.text != ""){
            AddShoppingField.text = SuggestionButtonVar
            AddShoppingButton(self)
        }
    }
    
    @IBAction func AddShoppingButton(_ sender: Any) {
        
        if(AddShoppingField.text != ""){
            
            let itemsObject = UserDefaults.standard.object(forKey: "ShoppingListItems")
            
            var items:[String]
            
            if let tempItems = itemsObject as? [String]{
                
                items = tempItems
                
                items.append(AddShoppingField.text!)
                
                print(items)
            }
            else
            {
                
                items = [AddShoppingField.text!]
                
                //print(items)
                
            }
            
            UserDefaults.standard.set(items, forKey: "ShoppingListItems")
            
            //Try to add ingredient to common Ingredients
            
            addToCommonIngredients(Ingredient: AddShoppingField.text!)
            
            UserDefaults.standard.set(commonIngredients, forKey: "commonIngredients")
            
            //Reset form and vars
            
            AddShoppingField.text = ""
            
            SuggestionButtonVar = ""
            
            SuggestionButtonOutlet.setTitle("", for: .normal)
            
        }
        else{
            showAlert(title: "oops!", message: "You haven't typed anything.")
        }
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationItem.title = nil
    }

    
    override func viewDidAppear(_ animated: Bool) {
        AddShoppingField.becomeFirstResponder()
        
        commonIngredients = LoadCommonIngredients()
    }
    
    func LoadCommonIngredients() -> [String]{
        if(UserDefaults.standard.object(forKey: "commonIngredients") != nil ){
            commonIngredients = UserDefaults.standard.object(forKey: "commonIngredients") as! [String]
        }
        else{
            commonIngredients = []
        }
        return commonIngredients
    }

    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Textfield Text changed
    @IBAction func IngredientTextChanged(_ sender: UITextField) {
        if(AddShoppingField.text != ""){
            makeSuggestions(InputSoFar: AddShoppingField.text ?? "")
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
            if(AddShoppingField.isEditing){
                SuggestionButtonOutlet.setTitle(matchingTerms[0], for: .normal)
                SuggestionButtonVar = matchingTerms[0]
                
            }
        }
        else{
            SuggestionButtonOutlet.setTitle("", for: .normal)
            SuggestionButtonVar = ""
        }
        
    }
    
    func addToCommonIngredients(Ingredient: String){
        if(!commonIngredients.contains(Ingredient)){
            commonIngredients.append(Ingredient)
        }
    }

}
