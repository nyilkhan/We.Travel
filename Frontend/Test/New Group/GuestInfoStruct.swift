//
//  GuestInfoStruct.swift
//  Test
//
//  Created by Sally on 4/24/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

class information {
    
    static let shared = information()
    
    var lat: Double?
    var long: Double?
    
    init(){
        lat = nil
        long = nil
    }
    
    
}
