//
//  YelpDataModel.swift
//  sally201UI
//
//  Created by Sally on 4/17/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import Foundation

class YelpDataModel {
    
    static let shared = YelpDataModel()
    
    var yelpDataArr : [YelpData?]
    var chosenActivities : [YelpData?]
    
    init(){
        
        yelpDataArr = [YelpData?]()
        chosenActivities = [YelpData?]()
        
        /*let tempData = YelpData(Address: "address", Price: "$$$", Rating: "4.5", Image: "http://downtown-brooklyn.imgix.net/imgr/Panda-Express.jpg?fm=jpg&auto=compress,enhance,format&w=1200", URL: "https://www.pandaexpress.com", Name: "Panda Express")
        
        yelpDataArr.append(tempData)*/
        
    }
    
    func decodeToYelpData(dic: [String: String]) -> YelpData{
        
        let restaurant = YelpData(Address: dic["Address"] ?? "", Price: dic["Price"] ?? "", Rating: dic["Rating"] ?? "", Image: dic["Image"] ?? "", URL: dic["URL"] ?? "", Name: dic["Name"] ?? "")
        
        return restaurant
        
    }
    
    //send json in request, recieve json response,
    //update yelp data array accordingly
    //check for cases with < 5 responses
    
    //returns true if success
    func populateFromAPI (searchTerm: String, cityName: String?, lat: Double?, long: Double?,
                          _ completionHandler: @escaping (_ responseArray: [YelpData]) -> ()) {
        
        print("\(searchTerm)|\(cityName ?? "")|nil|nil")
        
        let dataString = "\(searchTerm)|nil|\(lat!)|\(long!)".data(using: .utf8)
        print("\(searchTerm)|nil|\(lat!)|\(long!)")
        
        
        if let url = URL(string: "https://csci201.herokuapp.com/YelpApiCall"){
            
            var request = URLRequest(url: url)
            request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = dataString
            
            
            
            URLSession.shared.dataTask(with: request){ (data, response, err) in
                
              
                var list = [YelpData]()
                
                if let data = data {
                    
                    let JSONString = String(decoding: data, as: UTF8.self)
                    var jsonArr = JSONString.split(separator: "}")
                    
                    for i in 0..<jsonArr.count{
                        jsonArr[i] = jsonArr[i] + "}"
                        print(jsonArr[i])
                    }
                    
                    
                    print("First Element: \(jsonArr[0])")

                    
                    
                    for i in 0..<jsonArr.count{
                        let jsondata = jsonArr[i].data(using: .utf8)!
                        do {
                            if let jsonArray = try JSONSerialization.jsonObject(with: jsondata, options: []) as? [String: String]
                            {
                                
                                let newRestaurant = self.decodeToYelpData(dic: jsonArray)
                                list.append(newRestaurant)
                                
                                
                            } else {
                                print("bad json")
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                    
                    completionHandler(list)
            
                    
                }
            }.resume()
            
        }
        
        //clear data if not nil

    }
    
    //returns false if there are already 15 chosen activities
    //returns true if successful
    func addActivity (activity: YelpData) -> Bool{
        return true
    }
    
    
}
