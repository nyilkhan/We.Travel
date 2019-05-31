//
//  TripTableViewCell.swift
//  sally201UI
//
//  Created by Sally on 4/20/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {


    @IBOutlet weak var airplaneImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setData(city: String, date: String){
        
        cityLabel.text = city
        dateLabel.text = date
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
