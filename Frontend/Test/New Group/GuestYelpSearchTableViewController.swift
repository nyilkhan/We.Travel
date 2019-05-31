//
//  RestaurantTableViewController.swift
//  sally201UI
//
//  Created by Sally on 4/17/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit
import SDWebImage

class GuestYelpSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var isSearching = false;
    
    let sharedInstance = YelpDataModel.shared
    let shared = information.shared
    
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
        
        print(shared.lat!)
        print(shared.long!)

        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Food")! as! GuestTableViewCell
        cell.selectionStyle = .none
        
        //get the image
        if let activity = sharedInstance.yelpDataArr[indexPath.section]{
            
            let url = URL(string: activity.Image)
            
            cell.setData(foodImageURL: url, title: activity.Name)
        } else {
            let url = URL(string: "")
            cell.setData(foodImageURL: url, title: "Panda Express")
        }
        
        
        
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
            sharedInstance.populateFromAPI(searchTerm: term, cityName: "", lat: shared.lat, long: shared.long, closure)
            
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
    
    
    
    //perform shouldPrepareSegue to check for errors
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "information"){
            let infoViewController = segue.destination as! GuestRestaurantViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                infoViewController.data = sharedInstance.yelpDataArr[indexPath.section]
            }
        }
    }
    
}
