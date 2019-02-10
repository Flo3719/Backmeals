//
//  CupboardViewController.swift
//  Backpacker Food
//
//  Created by Florian Fahrenholz on 19.01.19.
//  Copyright © 2019 Florian Fahrenholz. All rights reserved.
//

import UIKit
import GoogleMobileAds

//Declared out here so it can be accessed by the Recepie detail viewcontroller class
//var CupboardItems:[String] = ["Currypowder", "Lentils", "Tomatoes", "Salt", "Spaghetti", "Frozen Vegetables"]



var CupboardItems: [String] = []



class CupboardViewController: UIViewController, UITabBarDelegate, UITableViewDataSource,  GADBannerViewDelegate {
    
    //ADS
    @IBOutlet weak var Mybanner: GADBannerView!
    
    
    //FUNCTIONALITY
    @IBOutlet weak var CupboardTableView: UITableView!
    
    @IBOutlet weak var EmptyBackpackView: UIView!
    
    //MEAL RECOMMENDATION
    
    @IBOutlet weak var ChefRecommendationHeadline: UILabel!

    @IBOutlet weak var RecommendedMealOutlet: UIButton!
    
    @IBAction func RecommendedMealButton(_ sender: Any) {
        
        GoToRecMeal()
        
    }
    
    func GoToRecMeal(){
        if(RecommendedMealOutlet.titleLabel?.text != nil){
            performSegue(withIdentifier: "GoToRecipeDetailsFromBackpack", sender: self)
            print("DER TEXT: ",RecommendedMealOutlet.titleLabel?.text)
        }
    }
    
    
    func MealRecommendation() -> RecepieElement{
        
       // var recommendedDishString: String = ""
        var recommendedDishElement: RecepieElement = (RecepieElement(Name:"", Ingredients:[]))
        
        CupboardItems = readCupboardItems()
        var LoadedRecipesSections: [RecipeSection] = ReadRecipesSections()
        
        
        
        if(LocalRecipesAvailable && CupboardItems.count > 0){
            let LocalRecipes = LoadedRecipesSections[1].SectionObjects
            
            var BestRecipeScore: Int = 9999
            
            if(LocalRecipes!.count > 0){
                print("123 ______________________________________________")
                for i in 1...LocalRecipes!.count{
                    //print("123 1")
                    
                    print("123 Name: ",LocalRecipes![i-1].Name!)
                    var HaveIngredientScore: Int = 0
                    var RecipeScore: Int = 0
                    
                   // print("123 Igredients: " )
                    //for j in 1...LocalRecipes![i-1].Ingredients.count{
                        //print("123 2")
                        //print(LocalRecipes![i-1].Ingredients[j-1])
                        for k in 1...CupboardItems.count{
                            //print("123 3")
                            if LocalRecipes![i-1].Ingredients.contains(CupboardItems[k-1]){
                                HaveIngredientScore += 1
                                print("123",CupboardItems[k-1])
                            }
                        }
                    //}
                   // HaveIngredientScore -= 1

                    print("123 haveingscore", HaveIngredientScore)
                    print("123 Ingredientscount", LocalRecipes![i-1].Ingredients.count)
                    RecipeScore =  LocalRecipes![i-1].Ingredients.count - HaveIngredientScore
                    print("123 recipe score:   ", RecipeScore)
                    
                    
                    if(RecipeScore <= BestRecipeScore){
                        //RecipeScore -= 1
                        //recommendedDishString = LocalRecipes![i-1].Name!
                        recommendedDishElement = LocalRecipes![i-1]
                        BestRecipeScore = RecipeScore
                    }
                    print("123 Best recipe score:   ", BestRecipeScore)
                    
                    
                }
                
            }
            //print("Local Recipes stuff: ", LocalRecipes)
            
        }
        
        
        
    
        return recommendedDishElement
    }
    

    
    func ReadRecipesSections() -> [RecipeSection]{
        
        let InstanceOfRecipesVC = RecepiesViewController()
       
        var LoadedRecipes: [RecipeSection]
        
        LoadedRecipes = InstanceOfRecipesVC.readAllRecipes()
        
        
        return LoadedRecipes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Hide empty cells
        self.CupboardTable.tableFooterView = UIView()
        
        
        //REquest
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "042A0B3BD2278001419902288093126736463A5764274669"]
        
        //Set up ad
        // TESTAD Mybanner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        Mybanner.adUnitID = "ca-app-pub-9665154923016795/9851201415"
        Mybanner.rootViewController = self
        Mybanner.delegate = self
        Mybanner.load(request)
        
    }
    
    

    //TableView:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CupboardItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        //Hex : f7f5fb
        cell.backgroundColor = UIColor(red:0.97, green:0.96, blue:0.98, alpha:1.0)
        
        //cell.textLabel?.font = UIFont(name:"Quicksand-Regular.otf", size:12)!
        cell.textLabel!.font = UIFont(name:"Quicksand", size:22)

        
        var cellLabel = ""
        
        if let tempLabel = CupboardItems[indexPath.row] as? String{
            cellLabel = tempLabel
        }
        
        cell.textLabel?.text = cellLabel
        
        if(cellLabel == nil){
            cell.isHidden = true
        }
        else{
            cell.isHidden = false
        }
        
        return cell
        
        
    }
    

    @IBOutlet weak var CupboardTable: UITableView!
    
    func readCupboardItems() -> [String]{
        CupboardItems = UserDefaults.standard.array(forKey: "BackpackItems") as? [String] ?? []
        //print("Cupboard Items: ")
        //print(CupboardItems)
        return CupboardItems
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //RecommendedMealOutlet.titleLabel?.text = MealRecommendation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        
        
        CupboardItems = readCupboardItems()
        EmptyBackpackView.isHidden = true
        
        
        //Clear Bugs from Cupboarditems
        if(CupboardItems.count >= 1){
            CupboardItems = CupboardItems.filter{$0 != ""}
            for i in 1...CupboardItems.count{
                CupboardItems[i-1] = CupboardItems[i-1].capitalized
            }
            CupboardItems = Array(Set(CupboardItems))
        }
        //print("Cupboard Items after filter: ")
        //print(CupboardItems)
        
        UserDefaults.standard.set(CupboardItems, forKey: "BackpackItems")
        
        //Hide Tableview if empty and show label instead
        if(CupboardItems == []){
            self.CupboardTableView.isHidden = true
            EmptyBackpackView.isHidden = false
        }
        else{
            self.CupboardTableView.isHidden = false
            EmptyBackpackView.isHidden = true
        }
        
        
        let itemsObject = UserDefaults.standard.object(forKey: "BackpackItems")
        //let itemsObject = CupboardItems
        
        if let tempItems = itemsObject as? [String]{
            
            CupboardItems = tempItems
            

        }

        refreshMealRecommondation()
        CupboardTableView.reloadData()
    }
    
    func refreshMealRecommondation(){
        
        let recommendedMealTitle: String! = MealRecommendation().Name!
        
        RecommendedMealOutlet.setTitle(recommendedMealTitle, for: .normal)
        print("3719: ", recommendedMealTitle)
        if(recommendedMealTitle == ""){
            ChefRecommendationHeadline.isHidden = true
        }
        else{
            ChefRecommendationHeadline.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
        if editingStyle == UITableViewCellEditingStyle.delete{
            
            
            CupboardItems.remove(at: indexPath.row)
            
            UserDefaults.standard.set(CupboardItems, forKey: "BackpackItems")
            self.viewWillAppear(false)
            
            CupboardTable.reloadData()
            //Reload View to see if it's empty so the empty-text can be shown
            self.viewDidAppear(false)
            
            refreshMealRecommondation()

            
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoToRecipeDetailsFromBackpack"){
            var vc = segue.destination as! RecepieDetailViewController
            vc.PreviousVCName = "Backpack"
        }
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
