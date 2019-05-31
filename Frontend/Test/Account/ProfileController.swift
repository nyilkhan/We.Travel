//
//  ProfileController.swift
//  Test
//
//  Created by David on 3/27/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    @IBOutlet var birthday: UIView!
    @IBOutlet var sex: UIView!
    
    @IBOutlet var viewer: UIView!
    @IBOutlet var birthtag: UILabel!
    @IBOutlet var sextag: UILabel!

    @IBOutlet var background: UIView!
    
    @IBOutlet var ProfilePic: UIImageView!
    @IBOutlet var profileview: UIView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var UpdatePic: UIButton!
    var imagePicker: ImagePicker!
    //let GET_Pic = ProfilePicModel.sharedInstance
    
    override func viewDidLoad() {
        Name.text = LoggedInUser
        Name.textColor = UIColor.black
        Name.adjustsFontSizeToFitWidth = true
        background.backgroundColor = UIColor.white
        load()
        profileview.backgroundColor = UIColor.groupTableViewBackground
        birthday.backgroundColor = UIColor.white
        sex.backgroundColor = UIColor.white
        
        birthtag.textColor = UIColor.black
        sextag.textColor = UIColor.black
        viewer.backgroundColor = UIColor(red:0.13, green:0.16, blue:0.4, alpha:1.0)
        super.viewDidLoad()
    }
    
    @IBAction func Logout(_ sender: UIButton) {
        LoggedInUser = ""
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ViewController = storyBoard.instantiateViewController(withIdentifier: "Login")
        self.present(ViewController, animated: true, completion: nil)
    }
    func load()
    {
        let ref = Database.database().reference(fromURL: "https://csci201final-bfe14.firebaseio.com/")
        ref.child("User").child(LoggedInUser).child("url").observeSingleEvent(of: .value) { snapshot in
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
                        self.ProfilePic.image = UIImage(data: data!)
                    }
                }
                task.resume()
            }
        }
    }
    
    @IBAction func UploadPic(_ sender: UIButton) {
        print("UpLoad Image button touched")
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
}

extension ProfileController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.ProfilePic.image = image
        let storageRef = Storage.storage().reference().child(LoggedInUser + ".png")
        if let uploadData = self.ProfilePic.image!.pngData()
        {
            storageRef.putData(uploadData, metadata: nil, completion:
            {
                (metadata, error) in
                if error != nil
                {
                    print(error)
                    return
                }
                //print(metadata)
                storageRef.downloadURL
                {
                    url, error in
                    if let error = error
                    {
                        print (error)
                    }
                    if let profileimageurl = url
                    {
                        let Values = ["name": LoggedInUser,"url": profileimageurl.absoluteString]
                        self.registerimage(uid: LoggedInUser, value: Values)
                    }
                }
            })
        }
    }
    
    func registerimage(uid: String, value: [String: String] )
    {
        let ref = Database.database().reference(fromURL: "https://csci201final-bfe14.firebaseio.com/")
        let usersReference = ref.child("User").child(uid)
        usersReference.updateChildValues(value, withCompletionBlock:
            { (error, ref) in
                if error != nil{
                    print(error)
                    return
                }
                //self.dismiss(animated: true, completion: nil)
        })
    }
}
