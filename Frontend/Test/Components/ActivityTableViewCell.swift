//
//  ActivityTableViewCell.swift
//  sally201UI
//
//  Created by Sally on 4/17/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
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
        addButton.imageView?.image = UIImage(named: "plus")
        
    }
    @IBAction func buttonWasPressed(_ sender: UIButton) {
        
        if let res = YelpDataModel.shared.yelpDataArr[getIndexPath()?.section ?? 0]{
            data.Restaurants.append(res)
        }
        addButton.setImage(UIImage(named: "check"), for: .normal)
        
    }
    
    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/

}
