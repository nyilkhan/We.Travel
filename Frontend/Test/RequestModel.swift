//
//  RequestModel.swift
//  Test
//
//  Created by David on 4/12/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

class RequestModel {
    static let sharedInstance = RequestModel()
    var RequestSet : [RMessage] = []
    
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
    
    func GetAllRequest(_ callback: @escaping () -> ())
    {
        RequestSet = []
        let json: [String: Any] =
        [
            "username": LoggedInUser,
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "https://csci201.herokuapp.com/PullFriendRequest")!
        //let url = URL(string: "http://localhost:8080/CSCI201_Final/PullFriendRequest")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        var test : String = ""
        //var information : String = ""
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
            let someVar : String = information![0]["info"] as! String
            print("information key: " + someVar)
            //Display login_related errors
            if someVar == "yes"
            {
                //self.Info_Field.text = "No Request"
            }
            else if someVar == "no"
            {
                let request : [String] = information?[0]["sender"] as! [String]
                for stuff in request
                {
                    self.RequestSet.append(RMessage(text: stuff))
                    print(stuff)
                }
            }
            DispatchQueue.main.sync {
                callback()
            }
            //
        }
        task.resume()
    }
}
