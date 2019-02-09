//
//  SettingsViewController.swift
//  Backpacker Food
//
//  Created by Florian Fahrenholz on 08.02.19.
//  Copyright © 2019 Florian Fahrenholz. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBAction func ResetTypingButton(_ sender: UIButton) {
        
        showAlert(title: "Reset typing suggestions", message: "Are you sure you want to reset the typing suggestions for ingredients?")
        
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "RESET", style: UIAlertActionStyle.default, handler: { action in
            switch action.style{
            case .default:
                print("RESET default")
                UserDefaults.standard.set(nil, forKey:"commonIngredients")
                
            case .cancel:
                print("RESET cancel")
                
            case .destructive:
                print("RESET destructive")
                
                
            }}))
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
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
