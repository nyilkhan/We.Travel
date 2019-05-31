//
//  Friend_Request_PageController.swift
//  Test
//
//  Created by David on 4/11/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit


class Friend_Request_PageController: UITableViewController, TableViewCellDelegate
{
    func ButtonTapped(_ cell: FriendRequestCell) {
        print ("Function triggered in friendrequest list!")
        if let indexPath = tableView.indexPath(for: cell)
        {
            //tableView.beginUpdates()
            let indexSet = NSMutableIndexSet()
            indexSet.add(indexPath.section)
            //print("Radio Tapped at \(indexPath)")
            requestModel.RequestSet.remove(at: indexPath.section)
            //self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            self.tableView.deleteSections(indexSet as IndexSet, with: UITableView.RowAnimation.fade)
            //tableView.endUpdates()
        }
    }
    
    fileprivate let cellId = "id"
    
    @IBOutlet weak var Info_Field: UILabel!
    let requestModel = RequestModel.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Friend Request"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(FriendRequestCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        requestModel.GetAllRequest
        {
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return requestModel.RequestSet.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendRequestCell
        let requestMessage = requestModel.RequestSet[indexPath.section]
        cell.RequestMessage = requestMessage
        //let task = tasks[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        //print(cell.RequestMessage.text)
        return cell
    }
}
