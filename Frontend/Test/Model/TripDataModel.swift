//
//  TripDataModel.swift
//  sally201UI
//
//  Created by Sally on 4/19/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import Foundation


class TripDataModel {
    
    static let sharedInstance = TripDataModel()
    
    var currentTrips: [Trip]
    //var pendingTrips: [TripData]
    //var historyTrips: [TripData]
    
    init(){
        
        currentTrips = [Trip]()
        
        /*currentTrips.append(Trip(tripId: "-1", longitude: "33.33", latitude: "44.44", hotel: "nah", cost: "50.45", date_Begin: "2019-12-19", date_End: "2019-12-26", feature: "no", friend: friends, flight: "nope", userName: "Peter"))*/
        
        
        
    }
    
    

    
    func encodeTrip(trip: newTrip) -> Data?{
        
        var jsonData = Data()
        
        do {
            jsonData = try JSONEncoder().encode(trip)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]

        } catch { print(error); return nil }
        
        return jsonData
        
    }
    
    func decodeTrip(jsonData: Data) -> Trip?{
        
        var decodedTrip: Trip
        
        do {
             decodedTrip = try JSONDecoder().decode(Trip.self, from: jsonData)
             print(decodedTrip)
        } catch { print(error); return nil }
        
        return decodedTrip
        
    }
    

    func getCurrentTrips(user: User,  _ completionHandler: @escaping (_ responseArray: [Trip]) -> ()){
        
        if let url = URL(string: "https://csci201.herokuapp.com/userCheck"){
            
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
                        let trips = try decoder.decode([Trip].self, from: data)
                        completionHandler(trips)
                    } catch let parseError {
                        print(parseError)
                    }
                        
                        
                        /*let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : String]
                    
                        if let json = jsonSerialized {
                            let trrip = self.createTrip(dic: json)
                            self.currentTrips.append(trrip)
                        }
                        return*/
                    
                    
                   
                    
                } else { print("no data"); return}
            }.resume()
            
        }
        
        
        
    }
    
    func sendNewTrip(NewTrip: newTrip, _ completionHandler: @escaping () -> ()){
        

        if let url = URL(string: "https://csci201.herokuapp.com/NewTripWithRestaurants"){
            
            guard let jsonData = encodeTrip(trip: NewTrip) else {print("could not encode"); return}
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            
            URLSession.shared.dataTask(with: request){ (data, response, err) in
                
                if let data = data {
                    
                    let JSONString = String(decoding: data, as: UTF8.self)
                    print(JSONString)
                    completionHandler()
                    
                } else { print("no data"); return}
                }.resume()
            
        }
        
    }
    

    
    
}
