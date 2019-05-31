//
//  DestinationViewController.swift
//  FinalProject201
//
//  Created by Student on 3/28/19.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit
import CoreLocation

class DestinationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var findDestinationButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var data = TripData.shared
    //var defaultLat = 0.0; var defaultLong = 0.0;
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locationManager.location
        YelpDataModel.shared.yelpDataArr = [YelpData]()
            
        }
        
        /*if currentLocation != nil {
            defaultLat = currentLocation.coordinate.latitude
            defaultLong = currentLocation.coordinate.longitude
        }*/
        
        self.navigationItem.hidesBackButton = true
    }
    
    /*@IBAction func didSingleTap(_ sender: UITapGestureRecognizer) {
        
        nameTextField.resignFirstResponder()
        
    }*/
    
    
    
    @IBAction func nameDidChange(_ sender: Any) {
        
        data.cityName = nameTextField.text ?? ""
        print(data.cityName)
    }
    
    
    //Insert Google Maps here

    
    /*@IBAction func latEditingDidEnd(_ sender: UITextField) {
        
        if let latitude = latitudeTextField.text {
            data.lat = Double(latitude) ?? defaultLat
        }
        
    }
    
    @IBAction func longEditingDidEnd(_ sender: UITextField) {
        
        if let longitude = longitudeTextField.text {
            data.long = Double(longitude) ?? defaultLong
        }
        
    }*/
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "next" {
            if (data.long == nil || data.lat == nil){
                
                let alert = UIAlertController(title: "No Destination", message: "Please pick a destination to continue", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                
                return false
                
            } else if (data.cityName == ""){
                
                let alert = UIAlertController(title: "No Trip Name", message: "Please enter a trip name to continue", preferredStyle: .alert)
                
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
