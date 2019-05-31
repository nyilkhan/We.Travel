//
//  FriendProfileController.swift
//  Test
//
//  Created by David on 4/18/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit
import Firebase

class FriendProfileController: UIViewController {

    var username : String = ""
    var image : UIImage = UIImage(named: "add")!
    @IBOutlet var Name: UILabel!
    @IBOutlet var ProfilePic: UIImageView!
    @IBOutlet var CHAT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Name.text = username
    }
    
    
    @IBAction func chat(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "CHAT"
        {
            if let viewController = segue.destination as? NotificationViewController
            {
                viewController.chat_user = username
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load(name: username)
    }
    
    func load(name: String)
    {
        let ref = Database.database().reference(fromURL: "https://csci201final-bfe14.firebaseio.com/")
        ref.child("User").child(name).child("url").observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() { return }
            if let url = snapshot.value as? String {
                print(url)
                let profileURL = URL(string: url)
                let request = URLRequest(url: profileURL!)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if (error != nil)
                    {
                        print (error)
                        return
                    }
                    DispatchQueue.main.async {
                        self.ProfilePic.image = UIImage(data: data!)
                    }
                }
                task.resume()
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
