//
//  DateViewController.swift
//  FinalProject201
//
//  Created by Student on 3/29/19.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
   
    
    @IBOutlet weak var beginDatePicker: UIDatePicker!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var data = TripData.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        //set min date to today
        beginDatePicker.minimumDate = Date()
        endDatePicker.minimumDate = Date()
        
        //intialize end to a week from tomorrow
        let endDate = Calendar.current.date(byAdding: .day, value: 8, to: Date()) ?? Date()
        endDatePicker.date = endDate
        data.dateEnd = format.string(from: endDate)
        
        //initialize start to tomorrow
        let beginDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        beginDatePicker.date = beginDate
        data.dateBegin = format.string(from: beginDate)
        
        self.navigationItem.hidesBackButton = true
        
        
    }
    
    @IBAction func startValueChanged(_ sender: UIDatePicker) {
        
        let date = sender.date
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        data.dateBegin = format.string(from: date)
        
    }
    
    @IBAction func endValueChanged(_ sender: UIDatePicker) {
        
        let date = sender.date
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        data.dateEnd = format.string(from: date)
        
        
    }
    
    //insert error message if end < begin
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if (beginDatePicker.date > endDatePicker.date){
            return false
        }
        
        return true
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let yelpSearch = segue.destination as? RestaurantTableViewController{
            
            yelpSearch.data = data
            
        }
        
    }
    
}
