//
//  TripData.swift
//  sally201UI
//
//  Created by Sally on 4/19/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import Foundation

class TripData {
    
    static let shared = TripData()
    
    var lat: Double? = nil
    var long: Double? = nil
    var cityName: String = ""
    var dateBegin: String? = nil
    var dateEnd: String? = nil
    var budget: Double = 0.00
    var Restaurants: [YelpData] = [YelpData]()
    var Friends: [String] = [String]()
    
    
    init(){
        
    }
    
    
    
    
    func stringFromDate(date: Date) -> String {
        
        
        return "date"
        
    }
    
    
}
