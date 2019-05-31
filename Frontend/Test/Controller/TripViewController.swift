//
//  TripViewController.swift
//  sally201UI
//
//  Created by Sally on 4/20/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit

class TripViewController: UIViewController {

    var tripData: Trip?
    
    @IBOutlet weak var firstFriend: UILabel!
    @IBOutlet weak var secondFriend: UILabel!
    @IBOutlet weak var thirdFriend: UILabel!
    @IBOutlet weak var fourthFriend: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
   
    
    func loadData() {
        
        getFriends()
        cityLabel.text = tripData?.tripName
        dateLabel.text = getDateString()
        budgetLabel.text = "Budget: $\(tripData?.cost ?? "0.0")"
        
    }
    
    func getDateString() -> String {
        
        var beginString = "N/A"
        var endString = "N/A"
        
        let dateBegin = getDate(string: tripData?.date_Begin ?? "N/A")
        let dateEnd = getDate(string: tripData?.date_End ?? "N/A")
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        
        if let begin = dateBegin{
           beginString = formatter.string(from: begin)
        }
        
        if let end = dateEnd{
            endString = formatter.string(from: end)
        }
        
        return ("\(beginString) - \(endString)")
        
    }
    
    
    func getDate(string: String) -> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from: string)
        
        return date
        
    }
    
    func getFriends(){
        
        let friendArray = tripData?.friend.split(separator: ",")
        
        if friendArray?.count ?? 0 >= 1{
            if (friendArray?[0] != "none"){
                firstFriend.text = String(friendArray?[0] ?? "")
            } else {
                firstFriend.text = ""
            }
        } else {
            firstFriend.text = ""
        }
        
        if friendArray?.count ?? 0 >= 2{
            secondFriend.text = String(friendArray?[1] ?? "")
        } else {
            secondFriend.text = ""
        }
        
        if friendArray?.count ?? 0 >= 3{
            thirdFriend.text = String(friendArray?[2] ?? "")
        } else {
            thirdFriend.text = ""
        }
        
        if friendArray?.count ?? 0 >= 4{
            fourthFriend.text = String(friendArray?[3] ?? "")
        } else {
            fourthFriend.text = ""
        }
        
    }
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "foodList" && tripData?.restaurants[0] == nil){
            let alert = UIAlertController(title: "No Restaurants", message: "You do not have any restaurants listed for this trip", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        
            return false
        } else {
            return true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "foodList"){
            
            let infoViewController = segue.destination as! FoodListTableViewController
            
            if let data = tripData{
                infoViewController.trip = data
            }

        }
    }


}
