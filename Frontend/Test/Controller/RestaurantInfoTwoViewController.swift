//
//  RestaurantInfoViewController.swift
//  sally201UI
//
//  Created by Sally on 4/17/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit

class RestaurantInfoTwoViewController: UIViewController {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var titlePriceLabel: UILabel!
    
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var data: Restaurant? //fill in prepare for segue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = data{
            
            let titleString = "\(data.name) - \(data.price)"
            let rating = Double(data.rating)
            
            let url = URL(string: data.link)
            
            restaurantImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "plate"))
            titlePriceLabel.text = titleString
            addressLabel.text = data.address
            
            fillStar(star: starOne, rating: rating!)
            fillStar(star: starTwo, rating: rating!)
            fillStar(star: starThree, rating: rating!)
            fillStar(star: starFour, rating: rating!)
            fillStar(star: starFive, rating: rating!)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func fillStar(star: UIImageView, rating: Double){
        
        if ((star == starOne && rating > 0.4) ||
            (star == starTwo && rating > 1.4) ||
            (star == starThree && rating > 2.4) ||
            (star == starFour && rating > 3.4) ||
            (star == starFive && rating > 4.4)
            ){
            
            star.image = UIImage(named: "filled star")
        } else {
            star.image = UIImage(named: "starOutline")
        }
        
    }
    
    
    @IBAction func safariWasPressed(_ sender: UIButton) {
        
        guard let url = URL(string: "\(data!.link)") else { return }
        UIApplication.shared.open(url)
        
    }
    
    @IBAction func closeButtonWasPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /*
     guard let url = URL(string: "https://stackoverflow.com") else { return }
     UIApplication.shared.open(url)
     */
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     
    
}
