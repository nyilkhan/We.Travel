//
//  newTrip.swift
//  sally201UI
//
//  Created by Sally on 4/21/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import Foundation

struct newTrip : Codable{
    let longitude: String
    let latitude: String
    let hotel: String
    let cost: String
    let date_Begin: String
    let date_End: String
    let feature: String
    let friend: String
    let trip_name: String
    let userName: String
    let usernamesToAdd: String
    let restaurants: [newTripRes]

}
