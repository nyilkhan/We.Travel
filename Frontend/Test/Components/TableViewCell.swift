//
//  TableViewCell.swift
//  sally201UI
//
//  Created by Sally on 4/20/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var data = TripData.shared
    
    
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var restaurantLabel: UILabel!
    
    
    func setData(foodImageURL: URL?, title: String) {
        
        if let url = foodImageURL{
            foodImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "plate"))
        } else {
            foodImageView.image = UIImage(named: "plate")
        }
        
        restaurantLabel.text = title
        
    }

}
