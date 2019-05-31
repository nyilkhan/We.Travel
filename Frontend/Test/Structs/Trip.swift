//
//  Trip.swift
//  sally201UI
//
//  Created by Sally on 4/19/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import Foundation

struct Trip: Codable{
    
    var restaurants: [Restaurant?]
    var tripName: String
    var tripId: String
    var longitude: String
    var latitude: String
    var hotel: String
    var cost: String
    var date_Begin: String
    var date_End: String
    var feature: String
    var friend: String

    
}
