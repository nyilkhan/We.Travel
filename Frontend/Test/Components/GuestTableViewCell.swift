//
//  ActivityTableViewCell.swift
//  sally201UI
//
//  Created by Sally on 4/17/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit

class GuestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var data = TripData.shared
    
    
    /*override func awakeFromNib() {
     super.awakeFromNib()
     // Initialization code
     }*/
    
    func getIndexPath() -> IndexPath? {
        
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        
        let indexPath = superView.indexPath(for: self)
        print(indexPath?.row)
        return indexPath
    }
    
    func setData(foodImageURL: URL?, title: String) {
        
        if let url = foodImageURL{
            foodImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "plate"))
        } else {
            foodImageView.image = UIImage(named: "panda")
        }
        
        titleLabel.text = title
        
    }
    
    /*override func setSelected(_ selected: Bool, animated: Bool) {
     super.setSelected(selected, animated: animated)
     
     // Configure the view for the selected state
     }*/
    
}
