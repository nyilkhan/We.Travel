//
//  ReveiwTripViewController.swift
//  sally201UI
//
//  Created by Sally on 4/19/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit

class ReveiwTripViewController: UIViewController {

    var data = TripData.shared
    
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print("Lat: \(data.lat)")
        //print("Long: \(data.long)")
        print("cityName: \(data.cityName)")
        print("dateBegin: \(data.dateBegin ?? "date")")
        print("dateEnd: \(data.dateEnd ?? "date")")
        print("Budget: \(data.budget)")
        
        print("Restaurants: ")
        for i in 0..<data.Restaurants.count {
            print(data.Restaurants[i].Name)
        }
        
        print("Friends: ")
        for i in 0..<data.Friends.count {
            print(data.Friends[i])
        }
        
        var restaurantString = ""
        let restaurants = TripData.shared.Restaurants
        for i in 0..<5{
            
            if i < restaurants.count{
                restaurantString = restaurantString + "\(restaurants[i].Name)\n"
            }
            
        }
        
        var friendString = ""
        let friends = TripData.shared.Friends
        for i in 0..<5{
            
            if i < friends.count{
                friendString = friendString + "\(friends[i])\n"
            }
        }
        
        restaurantLabel.text = restaurantString
        tripNameLabel.text = data.cityName
        friendsLabel.text = friendString
        dateLabel.text = getDateString()
        
        
        
        
       
        self.navigationItem.hidesBackButton = true
        
    }
    

    
    /*func sendData(){
        let user = User(username: LoggedInUser, password: "N/A")
        let lat = data.lat ?? 0
        let long = data.long ?? 0
        
        let cost = String(format: "%.2f", data.budget)
        
        
        TripDataModel.sharedInstance.addTrip(long: long, lat: lat, cost: cost, date_Begin: "2019-06-01", date_End: "2019-07-01", user: user)
    }*/
    
    func getDateString() -> String {
        
        var beginString = "N/A"
        var endString = "N/A"
        
        let dateBegin = getDate(string: data.dateBegin ?? "N/A")
        let dateEnd = getDate(string: data.dateEnd ?? "N/A")
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
    
    func addTrip(long: Double, lat: Double, cost: String, date_Begin: String, date_End: String, user: User) -> newTrip{
        
        let res = TripData.shared.Restaurants
        var restaurants = [newTripRes]()
        
        for i in 0..<res.count{
            let restaurant = newTripRes(address: res[i].Address, price: res[i].Price, rating: res[i].Rating, image: res[i].Image, link: res[i].URL, name: res[i].Name)
            restaurants.append(restaurant)
        }
        
        let friends = FriendsModel.shared.myFriends
        var friendString = ""
        
        for i in 0..<friends.count{
            friendString = friendString + "\(friends[i].username),"
        }
        
        let data = TripData.shared
        
        let NewTrip = newTrip(longitude: String(data.long!), latitude: String(data.lat!), hotel: "nah", cost: String(data.budget), date_Begin: data.dateBegin ?? "", date_End: data.dateEnd ?? "", feature: "N/A", friend: friendString, trip_name: data.cityName, userName: LoggedInUser, usernamesToAdd: friendString, restaurants: restaurants)
        
        
        return NewTrip
    }
    
    
    @IBAction func sendWasPressed(_ sender: Any?) {
        
        
        
        let closure : () -> () = {
            
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "sent", sender: sender)
            }
            
            
        }
        
        let user = User(username: LoggedInUser, password: "N/A")
        let lat = data.lat ?? 0
        let long = data.long ?? 0
        
        let cost = String(format: "%.2f", data.budget)
        
        
        let trip = addTrip(long: long, lat: lat, cost: cost, date_Begin: "2019-06-01", date_End: "2019-07-01", user: user)
        
        TripDataModel.sharedInstance.sendNewTrip(NewTrip: trip, closure)
        
        
    }
    
    
    /*override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier != "save" { return true }
        
        let tripSize = TripDataModel.sharedInstance.currentTrips.count
        sendData()
        let closure : ([Trip]) -> () = { responseArray in
            
            for i in 0..<responseArray.count{
                print(responseArray[i].tripName)
            }
            
            DispatchQueue.main.sync{
                TripDataModel.sharedInstance.currentTrips = responseArray
                print(TripDataModel.sharedInstance.currentTrips.count)
            }
            
            
        }
        
        TripDataModel.sharedInstance.getCurrentTrips(user: User(username: LoggedInUser, password: "N/A"), closure)
        
        if TripDataModel.sharedInstance.currentTrips.count > tripSize {
            return true
        }
        
        return false
        
    }*/

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "save"){
            sendData()
            let closure : ([Trip]) -> () = { responseArray in
                
                for i in 0..<responseArray.count{
                    print(responseArray[i].tripName)
                }
                
                DispatchQueue.main.sync{
                    TripDataModel.sharedInstance.currentTrips = responseArray
                    print(TripDataModel.sharedInstance.currentTrips.count)
                }
                
                
            }
            
            TripDataModel.sharedInstance.getCurrentTrips(user: User(username: LoggedInUser, password: "N/A"), closure)
            
            let barViewControllers = segue.destination as! UITabBarController
            let nav = barViewControllers.viewControllers![0] as! UINavigationController
            let destinationViewController = nav.children[0] as! TripListTableViewController
            
            destinationViewController.tableView.reloadData()
            
            
            
            
        }
        
    }*/
    

}
