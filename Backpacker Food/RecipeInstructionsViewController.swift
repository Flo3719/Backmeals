//
//  RecipeInstructionsViewController.swift
//  Backpacker Food
//
//  Created by Florian Fahrenholz on 02.02.19.
//  Copyright © 2019 Florian Fahrenholz. All rights reserved.
//

import UIKit

var StepsForRecipe: [String] = ["Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis eni", "cook the carrots", "Spice the carrots"]

var StepHeadlines: [String] = ["📝 Preparation", "1️⃣", "2️⃣", "3️⃣"]

class RecipeStepTableViewCell: UITableViewCell{
    
    @IBOutlet weak var RecipeStepHeadline: UILabel!
    
    @IBOutlet weak var RecipeStepText: UILabel!
    
    
}






class RecipeInstructionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StepsForRecipe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! RecipeStepTableViewCell
        
        cell.RecipeStepHeadline?.text = StepHeadlines[indexPath.row]
        cell.RecipeStepText?.text = StepsForRecipe[indexPath.row]
        
        
        //Hex : f7f5fb
        cell.backgroundColor = UIColor(red:0.97, green:0.96, blue:0.98, alpha:1.0)
        
        cell.textLabel!.font = UIFont(name:"Quicksand", size:22)
        
        //let cellLabel = StepsForRecipe[indexPath.row]
        
        //print(cellLabel)
        //cell.textLabel?.text = cellLabel
        
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
