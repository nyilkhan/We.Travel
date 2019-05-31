//
//  BudgetViewController.swift
//  sally201UI
//
//  Created by Sally on 4/20/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController {

    @IBOutlet weak var budgetTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        
        
        
    }
    

    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let text = budgetTextField.text
        
        if text != nil && text != "" { return true }
        
        let alert = UIAlertController(title: "Budget Error", message: "Please enter valid numerical budget", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let number = budgetTextField.text{
            
            TripData.shared.budget = Double(number)!
            
        }
        
    }
    

}
