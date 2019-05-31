//
//  TripListTableViewController.swift
//  sally201UI
//
//  Created by Sally on 4/20/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit
import MapKit

class TripListTableViewController: UITableViewController {

    let shared = TripDataModel.sharedInstance
    let user = User(username: LoggedInUser, password: "N/A")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let closure : ([Trip]) -> () = { responseArray in
            
            for i in 0..<responseArray.count{
                print(responseArray[i].tripName)
            }
            
            DispatchQueue.main.async{
                self.shared.currentTrips = responseArray
                print(self.shared.currentTrips.count)
                self.tableView.reloadData()
            }
            
        }
        
        shared.getCurrentTrips(user: user, closure)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(shared.currentTrips.count)
        return shared.currentTrips.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripTableViewCell
        
        let tripForRow = shared.currentTrips[indexPath.row]
        let dateString = getDateString(trip: tripForRow)

        cell.setData(city: tripForRow.tripName, date: dateString)
        
        
        
//        if let activity = sharedInstance.currentTrips[indexPath.row]{
//
//            let url = URL(string: activity.Image)
//
//            cell.setData(foodImageURL: url, title: activity.Name)
//        } else {
//            let url = URL(string: "")
//            cell.setData(foodImageURL: url, title: "Panda Express")
//        }

        // Configure the cell...

        return cell
    }
    
    func getDateString(trip: Trip) -> String {
        
        var beginString = "N/A"
        var endString = "N/A"
        
        let dateBegin = getDate(string: trip.date_Begin)
        let dateEnd = getDate(string: trip.date_End)
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
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ error: Error?) -> ()){
        

        
        CLGeocoder().reverseGeocodeLocation(location){ placemarks, error in
            completion(placemarks?.first?.locality,
                                        error)
        }
    }
    
    /*func getCityName(trip: Trip) -> String{
        
        


    }*/
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tripInfo"){
            print("segue")
            let infoViewController = segue.destination as! TripViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                infoViewController.tripData = shared.currentTrips[indexPath.row]
            }
        }
    }
    

}
