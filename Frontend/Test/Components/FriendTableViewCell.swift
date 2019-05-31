//
//  FriendTableViewCell.swift
//  sally201UI
//
//  Created by Sally on 4/19/19.
//  Copyright © 2019 Sally. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var inviteButton: UIButton!
    
    var data = TripData.shared
    var friends = FriendsModel.shared
    
    override func awakeFromNib() {
        
        
    }

    //figure out how to store "invited" value
    @IBAction func inviteWasPressed(_ sender: UIButton) {
        
        data.Friends.append(friends.myFriends[getIndexPath()?.row ?? 0].username)
        
        invited()
        
        
    }
    
    func invited() {
        
        let animate = UIViewPropertyAnimator(duration: 0.3, curve: UIView.AnimationCurve.linear, animations: (fadeOutText))
        
        
        animate.addCompletion { (position) in
            
            self.inviteButton.setTitle("Invited!", for: .normal)
            self.inviteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28.0)
            self.inviteButton.backgroundColor = UIColor(red: 34.0/255.0, green: 147.0/255.0, blue: 37.0/255.0, alpha: 1)
            self.inviteButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1), for: .normal)
            
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: UIView.AnimationCurve.linear, animations: { () in
                
                self.fadeInText()
                
            })
            
            animator.startAnimation()
            
        }
        
        animate.startAnimation()
    }
    
    func getIndexPath() -> IndexPath? {
        
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
    
    func fadeOutText() {
        inviteButton.titleLabel?.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0)
        
    }
    
    func fadeInText() {
        
        inviteButton.titleLabel?.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
    }
    
    func turnGreen(){
        inviteButton.backgroundColor = UIColor(red: 34.0/255.0, green: 147.0/255.0, blue: 37.0/255.0, alpha: 1)
    }

}
