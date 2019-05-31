//
//  AddFriendController.swift
//  Test
//
//  Created by David on 4/11/19.
//  Copyright © 2019 David. All rights reserved.
//
import UIKit

class AddFriendController: UIViewController {
    
    @IBOutlet var friendsearch: UITextField!
    @IBOutlet var Error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func AddFriendClick(_ sender: UIButton) {
        let FriendIdSearch: String = self.friendsearch.text ?? ""
        let json: [String: Any] =
            [
                "find_friend": FriendIdSearch,
                "sender": LoggedInUser
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "https://csci201.herokuapp.com/add_friend")!
        //let url = URL(string: "http://localhost:8080/CSCI201_Final/add_friend")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        var test : String = ""
        let workQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        workQueue.sync
        {
            let task = URLSession.shared.dataTask(with: request)
            {
                data, response, error in
                guard let data = data, error == nil
                    else
                {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                test = String(decoding: data, as: UTF8.self)
                print ("test: " + test)
                DispatchQueue.main.async
                    {
                        print("test: " + test)
                        //Display login_related errors
                        if test == "{\"info\": \"Friend Request Sent!\"}"
                        {
                            self.Error.text = "Friend Request Sent!"
                        }
                        else if test == "{\"info\": \"Username doesn't exist!\"}"
                        {
                            self.Error.text = "Username doesn't exist!"
                        }
                }
                //                info_back = self.convertJsonStringToDictionary(test)
            }
            //self.Error.text = "Succeed"
            task.resume()
        }
    }
}
