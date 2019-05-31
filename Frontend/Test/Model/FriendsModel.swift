//
//  FriendsModel.swift
//  sally201UI
//
//  Created by Sally on 4/19/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import Foundation

class FriendsModel {
    
    static let shared = FriendsModel()
    
    var myFriends: [FriendStruct]
    var chosenFriends: [FriendStruct]
    
    init(){
        
        myFriends = [FriendStruct]()
        chosenFriends = [FriendStruct]()

        
    }
    
    
    //database call
    func getFriends(user: FriendStruct,  _ completionHandler: @escaping (_ response: [content]) -> ()){
        
        if let url = URL(string: "https://csci201.herokuapp.com/friendlist"){
            
            var jsonUser = Data()
            
            do {
                jsonUser = try JSONEncoder().encode(user)
                let jsonString = String(data: jsonUser, encoding: .utf8)!
                print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]
                
            } catch { print(error) }
            
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonUser
            
            
            URLSession.shared.dataTask(with: request){ (data, response, err) in
                
                if let data = data {
                    
                    let JSONString = String(decoding: data, as: UTF8.self)
                    print("data: \(JSONString)")
                    
                    let decoder = JSONDecoder()
                    do {
                        let friends = try decoder.decode([content].self, from: data)
                        completionHandler(friends)
                    } catch let parseError {
                        print(parseError)
                    }
                    
                    
                    
                    
                } else { print("no data"); return}
                }.resume()
        
        
            
        }
        
    }
    
    
}
