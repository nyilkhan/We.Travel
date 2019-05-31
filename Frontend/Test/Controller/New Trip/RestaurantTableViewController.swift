//
//  RestaurantTableViewController.swift
//  sally201UI
//
//  Created by Sally on 4/17/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantTableViewController: UITableViewController, UISearchBarDelegate {

    

    @IBOutlet weak var searchBar: UISearchBar!
    
    var data = TripData.shared
    
    var isSearching = false;
    
    let sharedInstance = YelpDataModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        searchBar.placeholder = "Sushi"
        tableView.rowHeight = 215
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.go
        self.navigationItem.hidesBackButton = true
        
        print(data.lat)
        print(data.long)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sharedInstance.yelpDataArr.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print ("Count \(sharedInstance.yelpDataArr.count)")
        
        
        return 1
        
    }

    //def need some error checks in here
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! ActivityTableViewCell
        cell.selectionStyle = .none
        
        //get the image
        if let activity = sharedInstance.yelpDataArr[indexPath.section]{
        
            let url = URL(string: activity.Image)
        
            cell.setData(foodImageURL: url, title: activity.Name)
        } else {
            let url = URL(string: "")
            cell.setData(foodImageURL: url, title: "Panda Express")
        }
        
        //cell.setData(foodImage: foodImage, title: "Panda Express")
        
        

        return cell
    }
    
    
    func loadResponse(){
        
        let closure : ([YelpData]) -> () = { responseArray in
            
            for i in 0..<responseArray.count{
                print(responseArray[i].Name)
            }
            
            DispatchQueue.main.async{
                self.sharedInstance.yelpDataArr = responseArray
                self.tableView.reloadData()
            }
        }
        
        if let term = searchBar.text{
            sharedInstance.populateFromAPI(searchTerm: term, cityName: "", lat: data.lat, long: data.long, closure)
            
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if searchBar.text == nil || searchBar.text == ""{ //if nothing in text bar, there's nothing to display
            
            isSearching = false
            tableView.reloadData()
            
        } else {
            
            isSearching = true
            loadResponse()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.resignFirstResponder()
        
        if searchBar.text == nil || searchBar.text == ""{ //if nothing in text bar, there's nothing to display
            
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
            
        } else {
            
            isSearching = true
            sharedInstance.populateFromAPI()
            tableView.reloadData()
            
        }
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
    
    
    //perform shouldPrepareSegue to check for errors

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "information"){
            let infoViewController = segue.destination as! RestaurantInfoViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                infoViewController.data = sharedInstance.yelpDataArr[indexPath.section]
            }
        }
    }

}
