//
//  RestaurantInfoViewController.swift
//  sally201UI
//
//  Created by Sally on 4/17/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit

class RestaurantInfoViewController: UIViewController {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var titlePriceLabel: UILabel!
    
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var data: YelpData? //fill in prepare for segue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = data{
            
            let titleString = "\(data.Name) - \(data.Price)"
            let rating = Double(data.Rating)
            
            let url = URL(string: data.URL)
            
            restaurantImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "plate"))
            titlePriceLabel.text = titleString
            addressLabel.text = data.Address
            
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
        
        guard let url = URL(string: "\(data!.URL)") else { return }
        UIApplication.shared.open(url)
        
    }
    
    /*
     guard let url = URL(string: "https://stackoverflow.com") else { return }
     UIApplication.shared.open(url)
     */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
