//
//  FriendModel.swift
//  Test
//
//  Created by David on 4/16/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FriendListing{
    static let sharedInstance = FriendListing()
    var FriendList : [FriendShow] = []
    
    init() {
        // GetAllRequest()
    }
    
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
    
    func LoadFriend(_ callback: @escaping () -> ())
    {
        FriendList = []
        let json: [String: Any] =
        [
            "username": LoggedInUser
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "https://csci201.herokuapp.com/friendlist")!
        //let url = URL(string: "http://localhost:8080/CSCI201_Final/friendlist")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        var test : String = ""
        var information : Array<Dictionary<String, AnyObject>>?
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
            information = self.convertJsonDataToDictionary(data)
            //dump(information)
            //print("size: " + String(information!.count))
            //print(information?[0]["info"]!)
            var list : [String] = []
            if (information != nil)
            {
                list = information![0]["content"] as! [String]
                for item in list
                {
                    self.FriendList.append(FriendShow (text: item))
                }
            }
            DispatchQueue.main.sync {
                callback()
            }
        }
        task.resume()
    }
}
