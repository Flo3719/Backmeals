//
//  RecepiesViewController.swift
//  Backpacker Food
//
//  Created by Florian Fahrenholz on 19.01.19.
//  Copyright © 2019 Florian Fahrenholz. All rights reserved.
//

import UIKit
import GoogleMobileAds

//The recepie which was chosen on the List so the Detail-View knows Which details to show.
//Declared out here to make it everywhere accessable
var recepieIndexRow = 0
var recepieIndexSection = 0

//Declaration
// The Struct how a recipe looks
struct RecepieElement: Codable {
    var Name: String!
    var Ingredients: [String]!
}
var LocalRecipesAvailable: Bool = false

//Section stuff
struct RecipeSection{
    var SectionName: String!
    var SectionObjects : [RecepieElement]!
}

var RecipeSectionsArray = [RecipeSection]()




class RecepiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate  {
    

    //UI Elements
    
    //CELL:
    
    @IBOutlet weak var RecipeNameCell: UILabel!
    
    @IBOutlet weak var RecipeNeededLabel: UILabel!
    
    

    @IBOutlet weak var Mybanner: GADBannerView!
    
    @IBOutlet weak var NoRecipesView: UIView!
    
    @IBOutlet weak var RecepiesTableView: UITableView!
    
    @IBOutlet weak var NoRecipesLabel: UILabel!
    
    override func viewWillDisappear(_ animated: Bool) {
        //UserDefaults.standard.set(AllRecepies, forKey: "AllRecepies")
    }

    
    //Does key in UserDefaults exist?
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    //func getResponse(completionHandler : ((isResponse : Bool) -> Void))
    //func readLocalRecipes(completionHandler : ((RecipesStruct : [RecepieElement]) -> Void)){
    
    //Function Loads The JSONData Recipes from the Userdefaults and converts them to [RecepieElement] if they exist
    func readLocalRecipes() -> [RecepieElement]{
        
        if isKeyPresentInUserDefaults(key: "EncodedAllRecipes"){LocalRecipesAvailable = true}
        
        //Check if There are recipes saved in the UserDefaults
        if(LocalRecipesAvailable){
            
            //Load JSON-formatted Data for LocalRecipes from userdefaults
            var LocalRecipesData = UserDefaults.standard.object(forKey: "EncodedAllRecipes") as! Data
            
            //Decode from Data to Struct
            var LocalRecipesStruct = try! JSONDecoder().decode([RecepieElement].self, from: LocalRecipesData) // Decoding our data
            //print("LocalRecipesStruct: ", LocalRecipesStruct) // decoded!!!!!
            //print(type(of: LocalRecipesStruct)) -> Array[RecipeElement]
            
           // print("readLocalRecipes returns: ", LocalRecipesStruct)
            
            return LocalRecipesStruct
        }
        else{
            return [RecepieElement(Name: "", Ingredients:[""])]
        }
    }
    
    func readAllRecipes() -> [RecipeSection]{
        let LocalRecipesHere = readLocalRecipes()
        let StockRecipesHere = LoadStockRecipes()
        
        let ArrayInThisFunc = setUpSections(StockRecipes: StockRecipesHere, OwnRecipes: LocalRecipesHere)
        return ArrayInThisFunc
    }
    
    func LoadStockRecipes() -> [RecepieElement]{
        
        //Load Stock Recipes from JSON File "StockRecipes"
        let StockRecipesFile = Bundle.main.url(forResource: "StockRecipes", withExtension: "json")
        //Convert the loaded JSON file in Data datatype
        let StockRecipesData = try! Data(contentsOf: StockRecipesFile!)
        
        var StockRecipesStruct = try! JSONDecoder().decode([RecepieElement].self, from: StockRecipesData)
        // StockRecipes Decoded now and ready for use

        return StockRecipesStruct
    }
    
   
    
    func SaveRecipes(RecepieElementArray : [RecepieElement]){
        do{
            //Encode from Struct to JSON-String
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let EncodedAllRecepies = try! encoder.encode(RecepieElementArray)
           // print("EncodedAllRecipes: ", String(data: EncodedAllRecepies, encoding: .utf8)!)
            //print(type(of: EncodedAllRecepies)) -> Data
            //Save Data to UserDefaults
            UserDefaults.standard.set(EncodedAllRecepies, forKey: "EncodedAllRecipes")
        } catch {
            //print("ERROR With Saveing [RecepieElement] to userdefaults")
            
        }
    }
    
    
    func AppendToArrays(StructToAppendTo: [RecepieElement], NewRecipeElement: RecepieElement) -> [RecepieElement]{
        var OutputStruct: [RecepieElement] = StructToAppendTo
        OutputStruct.append(NewRecipeElement)
        return OutputStruct
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide empty cells
        self.RecepiesTableView.tableFooterView = UIView()
        
        
        //REquest
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "042A0B3BD2278001419902288093126736463A5764274669"]
        
        //Set up ad
        Mybanner.adUnitID = "ca-app-pub-9665154923016795/9372565555"
        Mybanner.rootViewController = self
        Mybanner.delegate = self
        Mybanner.load(request)
        

    }
    
    // Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isKeyPresentInUserDefaults(key: "EncodedAllRecipes"){LocalRecipesAvailable = true}
//
//        if(LocalRecipesAvailable){
//            return readLocalRecipes().count
//        }else{
//            return 0
//        }
        let LocalRecipesHere = readLocalRecipes()
        let StockRecipesHere = LoadStockRecipes()
        
        let ArrayInThisFunc = setUpSections(StockRecipes: StockRecipesHere, OwnRecipes: LocalRecipesHere)
        
        return ArrayInThisFunc[section].SectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        //Hex : f7f5fb
        cell.backgroundColor = UIColor(red:0.97, green:0.96, blue:0.98, alpha:1.0)
        
        cell.textLabel!.font = UIFont(name:"Quicksand", size:22)
        
        

        
        if isKeyPresentInUserDefaults(key: "EncodedAllRecipes"){LocalRecipesAvailable = true}
        
        
        var cellLabel = ""
        var RecipesForTable: [RecepieElement]!
        
        if(LocalRecipesAvailable){
            RecipesForTable = readLocalRecipes()
        }

        
        var StockRecipesForTable = LoadStockRecipes()
        
        var RecipeSectionsForTable = setUpSections(StockRecipes: StockRecipesForTable, OwnRecipes: RecipesForTable as? [RecepieElement] ?? [RecepieElement(Name: "", Ingredients: [])])
        
        cell.textLabel?.text = RecipeSectionsForTable[indexPath.section].SectionObjects[indexPath.row].Name
        //cell.textLabel?.text = cellLabel
        
        
        
        
        return cell
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let LocalRecipesHere = readLocalRecipes()
        let StockRecipesHere = LoadStockRecipes()
        
        let ArrayInThisFunc = setUpSections(StockRecipes: StockRecipesHere, OwnRecipes: LocalRecipesHere)
        
        return ArrayInThisFunc[section].SectionName
    }
    
    // Go to Recepie Details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        recepieIndexRow = indexPath.row
        recepieIndexSection = indexPath.section
        // print(recepieIndex)
        performSegue(withIdentifier: "GoToRecepieDetails", sender: self)
    }
    
    // Delte Recepie
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        

        
            var LocalRecipes = readLocalRecipes()
        
        if editingStyle == UITableViewCellEditingStyle.delete{
            
            if(indexPath.section == 1){
                LocalRecipes.remove(at: indexPath.row)
                
                SaveRecipes(RecepieElementArray: LocalRecipes)
                
                self.viewDidAppear(false)
                RecepiesTableView.reloadData()
            }
            else{
                showAlert(title: "oops!", message: "You can't delete stock recipes, sorry!")
            }
            
            
            
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpSections(StockRecipes: [RecepieElement], OwnRecipes: [RecepieElement]) -> [RecipeSection]{
        RecipeSectionsArray = [RecipeSection(SectionName: "Stock Recipes", SectionObjects: StockRecipes), RecipeSection(SectionName: "Your Recipes", SectionObjects: OwnRecipes)]
        return RecipeSectionsArray
    }
    
    
   

    
    override func viewDidAppear(_ animated: Bool) {
        
        
        //Hide Tableview if empty and show label instead
        let LocalRecipes = readLocalRecipes()
        
        
//        if(LocalRecipes.count == 0){
//            
//            //RecepiesTableView.isHidden = true
//            //NoRecipesView.isHidden = false
//            
//        }
//        else{
//            //self.RecepiesTableView.isHidden = false
//            NoRecipesView.isHidden = true
//        }
        RecepiesTableView.reloadData()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

//END OF CLASS
}



//Close keyboard on tap function
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



//Load LocalRecipesJSON (not neccessary)
//        let LocalRecipesFile = Bundle.main.url(forResource: "LocalRecipes", withExtension: "json")
//        var LocalRecipesData = try! Data(contentsOf: LocalRecipesFile!)

//Save Data to JSON (not neccessary)
//        do {
//            let file = try FileHandle(forWritingTo: LocalRecipesFile!)
//            file.write(EncodedAllRecepies)
//            print("JSON data was written to the file successfully!")
//        } catch let error as NSError {
//            print("Couldn't write to file: \(error.localizedDescription)")
//        }



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


////The Array of structs of recepies
//var AllRecepies: [RecepieElement] = [
//    RecepieElement(Name: "Dal",Ingredients: ["Lentils", "Currypowder", "Tomatoes", "Chillipowder", "Onions"]),
//    RecepieElement(Name: "Spaghetti Bolognese",Ingredients: ["Tomatoesauce", "Spaghetti", "Salt", "Pepper"]),
//    RecepieElement(Name: "Fried vegetable with rice", Ingredients: ["Rice", "Onions", "Currypowder", "Brocolli", "Carrots"])
//]

//let LocalRecipes = """
//[
//{
//    "Name":"Vegan Oats",
//    "Ingredients":["Oats", "Ricemilk", "Bananas", "Jam"]
//},
//{
//    "Name":"Water",
//    "Ingredients":["Water"]
//},
//{
//    "Name":"Instant Noodles",
//    "Ingredients":["Instant Noodles", "Water", "Love"]
//},
//]
//""".data(using: .utf8)! // our data in native (JSON) format

