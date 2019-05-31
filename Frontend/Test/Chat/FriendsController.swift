////
////  FriendsController.swift
////  Test
////
////  Created by David on 3/29/19.
////  Copyright © 2019 David. All rights reserved.
////
//

//snapkit
import UIKit

class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recent"
        collectionView?.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
//        var Layer = CAGradientLayer()
//        Layer.frame = self.view.bounds
//        Layer.colors = [UIColor(red:0.54, green:0.97, blue:1.00, alpha:1).cgColor, UIColor(red:0.40, green:0.65, blue:1.00, alpha:1).cgColor]
//        Layer.zPosition = -1
//        self.view.layer.addSublayer(Layer)
        
        setupData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count
        {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        if let message = messages?[indexPath.item]
        {
            cell.message = message
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FP", sender: self)
    }
}

class MessageCell: BaseCell
{
    var message: Message?
    {
        didSet
        {
            name.text = message?.friend?.name
            if let profileImageName = message?.friend?.profileImageName
            {
                profileImageView.image = UIImage (named: profileImageName)
            }
            messagelabel.text = message?.text
            if let date = message?.date
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                timelabel.text = dateFormatter.string(from: date as Date)
            }
        }
        
        
    }
    
    let profileImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let name: UILabel =
    {
        let user_label = UILabel()
        user_label.text = "Aaron Cote"
        user_label.font = UIFont.systemFont(ofSize: 18)
        return user_label
    }()

    let messagelabel: UILabel =
    {
        let label = UILabel()
        label.text = "Guys we're having an extra midterm next Tuesday!"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timelabel: UILabel =
    {
        let label = UILabel()
        label.text = "12:00am"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    override func setupViews()
    {
        addSubview(profileImageView)
        addSubview(dividerView)
        
        setUpContainerView()
        
        profileImageView.image = UIImage(named: "Aaron_Cote")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0(68)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": profileImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(68)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": profileImageView]))
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-82-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": dividerView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": dividerView]))
    }
    
   
    
    private func setUpContainerView()
    {
        let container = UIView()
        //container.backgroundColor = UIColor.red
        addSubview(container)

        container.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-90-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : container]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : container]))

        addConstraint(NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

        container.addSubview(name)
        container.addSubview(messagelabel)
        container.addSubview(timelabel)
        name.translatesAutoresizingMaskIntoConstraints = false
        messagelabel.translatesAutoresizingMaskIntoConstraints = false
        timelabel.translatesAutoresizingMaskIntoConstraints = false
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0][v1(80)]-12-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : name, "v1" : timelabel]))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1(24)]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : name, "v1" : messagelabel]))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]-12-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : messagelabel]))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(20)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : timelabel]))
    }
}

extension UIView
{
    func addConstraintsWithFormat(format: String, views: UIView...)
    {
        var viewDictionary = [String: UIView]()
        for (index, view) in views.enumerated()
        {
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

class BaseCell: UICollectionViewCell
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        backgroundColor = UIColor.green
    }
}
