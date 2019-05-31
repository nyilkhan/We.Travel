//
//  FriendRequestCell.swift
//  Test
//
//  Created by David on 4/12/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate
{
    func ButtonTapped(_ cell: FriendRequestCell)
}

class FriendRequestCell: UITableViewCell {

    var delegate: TableViewCellDelegate?
    let RequestBackgroundView = UIView()
    let messageLabel = UILabel()
    let acceptButton = UIButton()
    let refuseButton = UIButton()
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

    
    var RequestMessage: RMessage!
    {
        didSet
        {
            RequestBackgroundView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0, alpha: 0.7)
            messageLabel.text = RequestMessage.text
            //print ("RequestMessage.text = " + RequestMessage.text)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(messageLabel)
        addSubview(acceptButton)
        acceptButton.isEnabled = true
        
        acceptButton.addTarget(self, action: #selector(FriendRequestCell.action(sender:)), for: UIControl.Event.touchUpInside)
        acceptButton.setTitle("Accept", for: .normal)
        addSubview(refuseButton)
        refuseButton.addTarget(self, action: #selector(FriendRequestCell.action(sender:)), for: UIControl.Event.touchUpInside)
        refuseButton.isEnabled = true
        refuseButton.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0, alpha: 0.7)
        acceptButton.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0, alpha: 0.7)
        refuseButton.setTitle("Refuse", for: .normal)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        refuseButton.translatesAutoresizingMaskIntoConstraints = false
        //messageLabel.numberOfLines = 0
        let constraints =
        [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            acceptButton.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            acceptButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            refuseButton.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            refuseButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
        ]
        NSLayoutConstraint.activate(constraints)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-28-[v0][v1(68)]-30-[v2(68)]-28-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : messageLabel, "v1" : acceptButton, "v2" : refuseButton]))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    func convertJsonDataToDictionary(_ inputData : Data) -> Array<[String:AnyObject]>?
    {
        guard inputData.count > 1 else{ return nil } // avoid processing empty responses
        do
        {
            return try JSONSerialization.jsonObject(with: inputData, options: []) as? Array<Dictionary<String, AnyObject>>
        }
        catch let error as NSError
        {
            print(error)
        }
        return nil
    }
    
    func AcceptRequest()
    {
        let json: [String: Any] =
        [
            "username": LoggedInUser,
            "from_who": RequestMessage.text
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "https://csci201.herokuapp.com/confirm")!
        //let url = URL(string: "http://localhost:8080/CSCI201_Final/confirm")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        //var test : String = ""
        //var information : String = ""
        //var information : Array<Dictionary<String, AnyObject>>?
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let _ = data, error == nil
                else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            //test = String(decoding: data, as: UTF8.self)
            DispatchQueue.main.async
            {
                //print("test: " + test)
                //print(data)
                //information = self.convertJsonDataToDictionary(data)
                //dump(information)
                //print("size: " + String(information!.count))
                //print(information?[0]["info"]!)
                //let someVar : String = information![0]["info"] as! String
                //print("information key: " + someVar)
                
            }
            //
        }
        task.resume()
    }
    
    @objc func action(sender:UIButton!)
    {
        if (sender == acceptButton)
        {
            print("Button Clicked")
            AcceptRequest()
            delegate?.ButtonTapped(self)
        }
        if (sender == refuseButton)
        {
            delegate?.ButtonTapped(self)
        }
    }
}
