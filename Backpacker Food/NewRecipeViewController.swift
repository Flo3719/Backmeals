//
//  NewRecipeViewController.swift
//  Backpacker Food
//
//  Created by Florian Fahrenholz on 20.01.19.
//  Copyright © 2019 Florian Fahrenholz. All rights reserved.
//

import UIKit

class NewRecipeViewController: UIViewController {
    
    var NewRecipeName: String = ""
    var NewRecipeIngredients: [String] = []
    var IngredientsTextfieldText: String = ""
    
    var IngredientInput: String = ""
    
    
    var commonIngredients: [String] = []
    
    var SuggestionButtonVar: String = ""
    


    @IBOutlet weak var SuggestionButtonOutlet: UIButton!
    
    @IBOutlet weak var RecipeNameTextfield: UITextField!
    
    @IBOutlet weak var IngredientTextfield: UITextField!
    
    @IBOutlet weak var IngredientListLabel: UILabel!
    
    //Suggestions Button Action
    @IBAction func SuggestionButtonAction(_ sender: Any) {
        if(SuggestionButtonOutlet.titleLabel!.text != ""){
            IngredientTextfield.text = SuggestionButtonVar
        }
    }
    
    func LoadRecipesFromUserDefaults() -> [RecepieElement]{
        var InstanceOfRecipes = RecepiesViewController()
        var LoadedRecipes: [RecepieElement] = InstanceOfRecipes.readLocalRecipes()
        return LoadedRecipes
    }
    
    @IBAction func SaveRecipeButton(_ sender: Any) {

        var LoadedRecipes = LoadRecipesFromUserDefaults()
        var InstanceOfRecipes = RecepiesViewController()
        
        
        //Check if input is valid etc
        if(RecipeNameTextfield.text != "" && NewRecipeIngredients != []){
            LoadedRecipes.append(RecepieElement(Name:RecipeNameTextfield.text!, Ingredients:NewRecipeIngredients))
            print("TempIngr: ", NewRecipeIngredients)
            NewRecipeIngredients.removeAll()
            
            //print("SAVED RECIPE:     ", LoadedRecipes)
            
            InstanceOfRecipes.SaveRecipes(RecepieElementArray: LoadedRecipes)
            
            //Back To recipes list
            navigationController?.popViewController(animated: true)
            
            
        }
        else if(RecipeNameTextfield.text == "" && NewRecipeIngredients == []){
            showAlert(title: "oops!", message: "Please enter a valid name & some ingredients to your recipe.")
        }
        else if(RecipeNameTextfield.text == "" && NewRecipeIngredients != []){
            showAlert(title: "oops!", message: "Please enter a valid name for your recipe.")
        }
        else if(RecipeNameTextfield.text != "" && NewRecipeIngredients == []){
            showAlert(title: "oops!", message: "Please add some ingredients to your recipe.")
        }
     
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hideKeyboardWhenTappedAround()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        RecipeNameTextfield.becomeFirstResponder()
        
        IngredientListLabel.text = ""
        
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
    

    //Textfield Text changed
    @IBAction func IngredientTextChanged(_ sender: UITextField) {
        if(IngredientTextfield.text != ""){
            makeSuggestions(InputSoFar: IngredientTextfield.text ?? "")
        }
        else{
            SuggestionButtonOutlet.setTitle("", for: .normal)
            SuggestionButtonVar = ""
        }
    }

    
    @IBAction func AddIngredientButton(_ sender: Any) {
        //Save the ingredient in the array of ingredients for this recipe
       // NewRecipeIngredients.append(IngredientTextfield.text!)
        
        //Add the Ingredient to the String which will be text of the ingredients list later
        
        //Try to add ingredient to common Ingredients
        
        
        addToCommonIngredients(Ingredient: IngredientTextfield.text!.capitalized)
        
        UserDefaults.standard.set(commonIngredients, forKey: "commonIngredients")
        
        IngredientsTextfieldText += IngredientTextfield.text!.capitalized
        IngredientInput = IngredientTextfield.text!.capitalized
        IngredientsTextfieldText += ", "
        
        
        
        //Clean Textfield
        IngredientTextfield.text = ""
        NewRecipeIngredients.append(IngredientInput)
        IngredientListLabel.text = IngredientsTextfieldText
        
        SuggestionButtonVar = ""
        
        SuggestionButtonOutlet.setTitle("", for: .normal)
    }
    
    func makeSuggestions(InputSoFar: String){
        //print("called MakeSuggestions")
        
        
        let matchingTerms = commonIngredients.filter({
            $0.range(of: InputSoFar, options: .caseInsensitive) != nil
        })
        
        if(matchingTerms != []){
            if(IngredientTextfield.isEditing){
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


//print()
// print("NewRecipe: ",AllRecepies)


// AllRecepies.append(NewRecepie)

//Encode AllRecipes to Data to save them in the user defaults
//        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: AllRecepies)
//        UserDefaults.standard.set(encodedData, forKey: "EncodedRecipes")
//        UserDefaults.standard.synchronize()
