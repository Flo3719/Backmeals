//
//  ShoppingListViewController.swift
//  Backpacker Food
//
//  Created by Florian Fahrenholz on 19.01.19.
//  Copyright © 2019 Florian Fahrenholz. All rights reserved.
//

import UIKit
import GoogleMobileAds

var Shoppinglist: [String] = []



class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var ShoppingListTable: UITableView!
    
    @IBOutlet weak var EmptyShoppinglistView: UIView!
    
    
    //@IBOutlet weak var Mybanner: GADBannerView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Shoppinglist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        

        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        //Hex : f7f5fb
        cell.backgroundColor = UIColor(red:0.97, green:0.96, blue:0.98, alpha:1.0)
        
        cell.textLabel!.font = UIFont(name:"Quicksand", size:22)


                
        
        let cellLabel = Shoppinglist[indexPath.row]
        
        //print(cellLabel)
        cell.textLabel?.text = cellLabel
        
        return cell
        
        
    }
    
// SWIPE ACTIONS
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let AddToCupboard = UIContextualAction(style: .normal, title: "buy") { (action, view, nil) in
            //What happens if you swipe right:
            //print("buy")
            
            //Add Item from Shoppinglist to cupboard and delete it from shoppinglist
            var OldUserDefaultsCupboard = UserDefaults.standard.object(forKey: "BackpackItems") as? [String] ?? [""]
            
            OldUserDefaultsCupboard = OldUserDefaultsCupboard.filter{$0 != ""}
                        
            //print("indexpath.row:  ",indexPath.row)
            OldUserDefaultsCupboard.append(Shoppinglist[indexPath.row])

            UserDefaults.standard.set(OldUserDefaultsCupboard, forKey: "BackpackItems")

            Shoppinglist.remove(at: indexPath.row)

            UserDefaults.standard.set(Shoppinglist, forKey: "ShoppingListItems")

            self.ShoppingListTable.reloadData()
            self.viewDidAppear(false)
            
   
        }
        return UISwipeActionsConfiguration(actions: [AddToCupboard])
    }

func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    
    if editingStyle == UITableViewCellEditingStyle.delete{
        
        Shoppinglist.remove(at: indexPath.row)
        
        UserDefaults.standard.set(Shoppinglist, forKey: "ShoppingListItems")
        
        ShoppingListTable.reloadData()
        viewDidAppear(false)
    }
    
    
}
    

    override func viewDidAppear(_ animated: Bool) {
        //Hide Tableview if empty and show label instead
        Shoppinglist = UserDefaults.standard.object(forKey: "ShoppingListItems") as! [String]
        
        if(Shoppinglist == []){
            
            self.ShoppingListTable.isHidden = true
            EmptyShoppinglistView.isHidden = false
            
        }
        else{
            self.ShoppingListTable.isHidden = false
            EmptyShoppinglistView.isHidden = true
        }
        ShoppingListTable.reloadData()
        //print(".........Shoppinglist:  ",Shoppinglist)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide empty cells
        self.ShoppingListTable.tableFooterView = UIView()
        
        //REquest
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID, "042A0B3BD2278001419902288093126736463A5764274669"]
//
//        //Set up ad
//        Mybanner.adUnitID = "ca-app-pub-9665154923016795/2227614846"
//        Mybanner.rootViewController = self
//        Mybanner.delegate = self
//        Mybanner.load(request)
        
        
        
        UserDefaults.standard.register(defaults: ["ShoppingListItems": []])
        Shoppinglist = UserDefaults.standard.object(forKey: "ShoppingListItems") as! [String]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Shoppinglist = UserDefaults.standard.array(forKey: "ShoppingListItems") as? [String] ?? []

        Shoppinglist = Shoppinglist.filter{$0 != ""}
        
        if(Shoppinglist.count >= 1){
            for i in 1...Shoppinglist.count{
                Shoppinglist[i-1] = Shoppinglist[i-1].capitalized
            }
            Shoppinglist = Array(Set(Shoppinglist))
        }
//
          UserDefaults.standard.set(Shoppinglist, forKey: "ShoppingListItems")
//
//        ShoppingListTable.reloadData()
        
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


//        if editingStyle == UITableViewCellEditingStyle.delete{

//Load Cupboard to add something
//DAS ZEUG IST RICHTIG (VIELLEICHT FAST)
//            var OldUserDefaultsCupboard = UserDefaults.standard.object(forKey: "CupboardItems") as? [String] ?? ["nil"]
//
//            OldUserDefaultsCupboard.append(Shoppinglist[indexPath.row])
//
//            UserDefaults.standard.set(OldUserDefaultsCupboard, forKey: "CupboardItems")
//
//            Shoppinglist.remove(at: indexPath.row)
//
//            UserDefaults.standard.set(Shoppinglist, forKey: "ShoppingListItems")
//
//            ShoppingListTable.reloadData()

//      }
