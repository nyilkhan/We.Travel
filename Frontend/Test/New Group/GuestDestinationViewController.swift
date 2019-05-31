//
//  GuestDestinationViewController.swift
//  Test
//
//  Created by Sally on 4/24/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit
import CoreLocation

class GuestDestinationViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var findDestinationButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var info = information.shared
    
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locationManager.location
            
        }
        
        /*if currentLocation != nil {
         defaultLat = currentLocation.coordinate.latitude
         defaultLong = currentLocation.coordinate.longitude
         }*/
        
        self.navigationItem.hidesBackButton = true
    }

    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "next" {
            if (info.lat == nil || info.long == nil){
                
                let alert = UIAlertController(title: "No Destination", message: "Please pick a destination to continue", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                
                return false
                
            }
        }
        
        return true
        
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     if let date = segue.destination as?  DateViewController{
     
     //print(data.destinationLong!)
     //print(data.destinationLat!)
     
     date.data = data
     
     }
     
     }*/
    
    
}



