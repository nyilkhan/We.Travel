//
//  FriendCell.swift
//  Test
//
//  Created by David on 4/15/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit
import Firebase


class FriendCell: UITableViewCell {

    let BackgroundView = UIView()
    let messageLabel = UILabel()
//    let button = UIButton()
    let container: UIView =
    {
        let view = UIView()
        return view
    }()
    let profileImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var Message: FriendShow!
    {
        didSet
        {
            BackgroundView.backgroundColor = UIColor(red:0.40, green:0.65, blue:1.00, alpha: 0.7)
            messageLabel.text = Message.text
            load(name: messageLabel.text!)
            if (self.profileImageView.image == nil)
            {
                self.profileImageView.image = UIImage(named: "add")!
            }
        }
    }
    
    func load(name: String)
    {
        
        let ref = Database.database().reference(fromURL: "https://csci201final-bfe14.firebaseio.com/")
        ref.child("User").child(name).child("url").observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() { return }
            if let url = snapshot.value as? String {
                //print(url)
                let profileURL = URL(string: url)
                let request = URLRequest(url: profileURL!)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if (error != nil)
                    {
                        print (error)
                        return
                    }
                    DispatchQueue.main.async {
                            self.profileImageView.image = UIImage(data: data!)
                    }
                }
                task.resume()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-90-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : container]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : container]))
        
        addConstraint(NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

        
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0(68)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": profileImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(68)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": profileImageView]))
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        backgroundColor = .clear
        container.addSubview(BackgroundView)
        container.addSubview(messageLabel)
//        container.addSubview(button)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        BackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        button.translatesAutoresizingMaskIntoConstraints = false;
        let constraints =
        [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
        ]
        NSLayoutConstraint.activate(constraints)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-28-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : messageLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : BackgroundView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-6-[v0]-6-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : BackgroundView]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}
