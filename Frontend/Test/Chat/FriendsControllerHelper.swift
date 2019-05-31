//
//  FriendsControllerHelper.swift
//  Test
//
//  Created by David on 4/9/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Friend: NSObject
{
    var name : String?
    var profileImageName: String?
}

class Message: NSObject
{
    var text : String?
    var date: NSDate?
    var friend: Friend?
}

extension FriendsController
{
    func setupData()
    {
//        var chat_friend: [String] = []
//        var recent_friend: [Friend] = []
//        let json: [String: Any] =
//        [
//            "username": LoggedInUser
//        ]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        //let url = URL(string: "https://csci201.herokuapp.com//Recent_Chat")!
//        let url = URL(string: "http://localhost:8080/CSCI201_Final/Recent_Chat")!
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody = jsonData
//        //let test : String = ""
//        //var information : String = ""
//        var information : Array<Dictionary<String, AnyObject>>?
//        let task = URLSession.shared.dataTask(with: request)
//        {
//            data, response, error in
//            guard let data = data, error == nil
//                else
//            {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            //var test = String(decoding: data, as: UTF8.self)
//            DispatchQueue.main.async
//            {
//                let json = try? JSONSerialization.jsonObject(with: data, options: [])
//                //print(json)
//                if let dictionary = json as? [String: Any] {
//                    if let array = dictionary["recentChat"] as? [Any] {
//                        //print (array.first)
//                        for item in array{
//                            chat_friend.append(item as! String)
//                        }
//                    }
//                }
//                for friend in chat_friend
//                {
//                    var imaging : UIImage = UIImage(named: "add")!
//                    let ref = Database.database().reference(fromURL: "https://csci201final-bfe14.firebaseio.com/")
//                    ref.child("User").child(friend).child("url").observeSingleEvent(of: .value) { snapshot in
//                        if !snapshot.exists() { return }
//                        if let url = snapshot.value as? String {
//                            //print(url)
//                            let profileURL = URL(string: url)
//                            let request = URLRequest(url: profileURL!)
//                            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                                if (error != nil)
//                                {
//                                    print (error)
//                                    return
//                                }
//                                DispatchQueue.main.async {
//                                    imaging = UIImage(data: data!)!
//                                }
//                            }
//                            task.resume()
//                        }
//                    }
//                    let temp_friend = Friend()
//                    temp_friend.name = friend;
//                    temp_friend.profileImageName = imaging
//                    recent_friend.append(temp_friend)
//                }
//                for item in recent_friend
//                {
//                    // pull last message and date
//                    let message = Message()
//                    print (item.profileImageName)
//                    message.friend = item
//                    message.text = "FUCKFUCKFUCKFUCKFUCK!"
//                    message.date = NSDate()
//                    self.messages?.append(message)
//                }
//            }
//            //
//        }
//        task.resume()
        
        
        let mark = Friend()
        mark.name = "Mark Redektop"
        mark.profileImageName = "Mark_Redekopp"

        let message = Message()
        message.friend = mark
        message.text = "CS Department is mine now!"
        message.date = NSDate()

        let mark1 = Friend()
        mark1.name = "Aaron Cote"
        mark1.profileImageName = "Aaron_Cote"

        let message1 = Message()
        message1.friend = mark1
        message1.text = "Bull Shit"
        message1.date = NSDate()

        let la = Friend()
        la.name = "Sally"
        la.profileImageName = "add"
        
        let mes = Message()
        mes.friend = mark
        mes.text = "This project sucks!"
        mes.date = NSDate()
        
        messages = [message, message1, mes]
    }
}
