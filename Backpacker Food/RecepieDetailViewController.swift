//
//  RecepieDetailViewController.swift
//  Backpacker Food
//
//  Created by Florian Fahrenholz on 19.01.19.
//  Copyright © 2019 Florian Fahrenholz. All rights reserved.
//

import UIKit

class RecepieDetailViewController: UIViewController {

    
    
    var NeededThingsArray: [String] = []
    
    
    @IBOutlet weak var AddToListButtonOutlet: UIButton!
    
    @IBOutlet weak var ChefsLabel: UILabel!
    
    @IBOutlet weak var DetailsNavbar: UINavigationBar!
    
    @IBOutlet weak var AllIngredientsList: UILabel!
    
    @IBOutlet weak var NeedToBuyList: UILabel!
    
    @IBOutlet weak var RecepieNameTitle: UILabel!
    
    @IBOutlet weak var NeedToBuyHeadline: UILabel!
    
    @IBAction func AddToShoppingList(_ sender: Any) {
        
        Shoppinglist.append(contentsOf: NeededThingsArray)
        
        //Load shoppinglist
        var OldUserDefaults = UserDefaults.standard.object(forKey: "ShoppingListItems") as? [String] ?? ["nil"]
        OldUserDefaults = OldUserDefaults.filter{$0 != ""}
        
        //Add The needed ingredients of this reciept to the local var shoppinglist 
        OldUserDefaults.append(contentsOf: NeededThingsArray)
        print("NEEDED THINGS ARRAY:", NeededThingsArray)
        
        //Convert to set and back to array to eliminate duplicates
        let NewUserDefaults = Array(Set(OldUserDefaults))
        
        UserDefaults.standard.set(NewUserDefaults, forKey: "ShoppingListItems")
        
    }
    



    
    override func viewWillAppear(_ animated: Bool) {
       

        
        var InstanceOfRecipes = RecepiesViewController()
        var LoadedRecipes: [RecepieElement] = InstanceOfRecipes.readLocalRecipes()
        
        var AllRecipes: [RecipeSection] = InstanceOfRecipes.readAllRecipes()
        
        
        print("Loaded Recipes: ", LoadedRecipes)
       

        
        //Load Ingredients from Cupboard (CupboardIngredients)
        var LoadedIngredients = UserDefaults.standard.object(forKey: "BackpackItems") as? [String] ?? ["nil"]
        print("LoadedIngredients: ", LoadedIngredients)
        
        //The owned ingredients for this recepie will be saved in this var
        var IHaveThis: [String] = []
        

        //Show name of the dish at the top
        RecepieNameTitle.text = AllRecipes[recepieIndexSection].SectionObjects[recepieIndexRow].Name
       

        // Loop Through alle ingredients
        var IngredientCount = AllRecipes[recepieIndexSection].SectionObjects[recepieIndexRow].Ingredients.count
        //var IngredientCount = LoadedRecipes[recepieIndexRow].Ingredients.count
        print("IngredientCount: ",IngredientCount)
        var IngredientsLabelText = ""
        var NeededIngredientsLabelText = ""
        for i in 1...IngredientCount{
            //Check if ingredient is NOT in Cupboard and then add it to "Need to buy" list
            if !LoadedIngredients.contains(AllRecipes[recepieIndexSection].SectionObjects[recepieIndexRow].Ingredients[i-1]){
                //print("DU BRAUCHST: ", LoadedRecipes[recepieIndex].Ingredients[i-1])
                
                //Ad Ingredients that are needed to the Label text that shows these.
                NeededIngredientsLabelText += AllRecipes[recepieIndexSection].SectionObjects[recepieIndexRow].Ingredients[i-1]
                NeededIngredientsLabelText += ", "
                NeededThingsArray.append(AllRecipes[recepieIndexSection].SectionObjects[recepieIndexRow].Ingredients[i-1])
            }

           // print("DU HAST: ", LoadedRecipes[recepieIndex].Ingredients[i-1])

            IngredientsLabelText += AllRecipes[recepieIndexSection].SectionObjects[recepieIndexRow].Ingredients[i-1]
            IngredientsLabelText += ", "
            
        }
        AllIngredientsList.text = IngredientsLabelText
        //if nothing is needed show text "You have all needed Ingredients"
        // and hide the headline "From that you need to Buy"
        if(NeededIngredientsLabelText == ""){
            NeedToBuyList.isHidden = true
            NeedToBuyHeadline.text = "You have everything!"
            ChefsLabel.isHidden = false
            AddToListButtonOutlet.isHidden = true
            
        }
        else{
            NeedToBuyHeadline.isHidden = false
            NeedToBuyList.text = NeededIngredientsLabelText
            ChefsLabel.isHidden = true
            AddToListButtonOutlet.isHidden = false
        }
        //Set the text of the label that shows the ingredients I aleady have
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
