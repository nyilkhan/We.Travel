//
//  ListController.swift
//  Test
//
//  Created by David on 4/15/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

class ListController: UITableViewController {
    fileprivate let cellId = "id_friend"
    let friendmodel = FriendListing.sharedInstance
    
    func convertJsonDataToDictionary(_ inputData : Data) -> Array<[String:AnyObject]>?
    {
        guard inputData.count > 1 else{ return nil } // avoid processing empty responses
        do
        {
            return try JSONSerialization.jsonObject(with: inputData, options: []) as? Array<Dictionary<String, AnyObject>>
        }
        catch let error as NSError
        {
            print(error)
        }
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        friendmodel.LoadFriend
        {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Friends"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(FriendCell.self, forCellReuseIdentifier: cellId)
        self.tableView.separatorColor = UIColor.clear
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendmodel.FriendList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendCell
        let Messages = friendmodel.FriendList[indexPath.section]
        cell.Message = Messages
        //print(cell.RequestMessage.text)
        cell.selectionStyle = .none
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCell.EditingStyle.delete {
//            friendmodel.FriendList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "FriendProfile", sender: self)
        print("Clicking on a cell!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "FriendProfile"
        {
            print("Should trigger here!")
            if let viewController = segue.destination as? FriendProfileController
            {
                if let indexPath = tableView.indexPathForSelectedRow{
                    let selectedSection = indexPath.section
                    //print("1")
                    viewController.username = friendmodel.FriendList[selectedSection].text
                }
            }
        }
    }
}
