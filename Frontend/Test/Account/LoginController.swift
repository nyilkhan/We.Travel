//
//  LoginPageViewController.swift
//  APP
//
//  Created by David on 3/27/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Foundation
var LoggedInUser: String = ""

class LoginPageViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var Error_Info: UILabel!
    @IBOutlet weak var guestButton: UIButton!
    
    // Change picture to round
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Logo.layer.borderWidth = 1
        Logo.layer.masksToBounds = false
        Logo.layer.borderColor = UIColor.black.cgColor
        Logo.layer.cornerRadius = Logo.frame.height/2
        Logo.clipsToBounds = true
        setupView()
        
    }
    
    // Background functions
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    private func setupView()
    {
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "Timelapsed", ofType: "mp4")!)
        let player = AVPlayer(url:path)
        let newLayer = AVPlayerLayer(player: player)
        newLayer.frame = self.videoView.frame
        self.videoView.layer.addSublayer(newLayer)
        newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        player.isMuted = true
        player.play()
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        NotificationCenter.default.addObserver(self, selector: #selector(LoginPageViewController.VideoDidPlayToEnd(_:)), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player.currentItem)
    }
    
    @objc func VideoDidPlayToEnd(_ notification : Notification)
    {
        let player: AVPlayerItem = notification.object as! AVPlayerItem
        player.seek(to: CMTime.zero)
    }

    //Click Behavior
    
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
    
    func convertJsonStringToDictionary(_ text: String) -> Array<Dictionary<String, AnyObject>>?
    {
        if let data = text.data(using: String.Encoding.utf8)
        {
            do
            {
            return try JSONSerialization.jsonObject(with: data, options: []) as? Array<Dictionary<String, AnyObject>>
            }
            catch let error as NSError
            {
                print(error)
                
            }
        }
        return nil
    }
    
    @IBAction func LoginButtonClick(_ sender: UIButton) {
        let username: String = self.usernameField.text ?? ""
        let password: String = self.passwordField.text ?? ""
        var error_exist: Bool = false;
        if username.count == 0
        {
            error_exist = true;
            self.Error_Info.text = "Username cannot be blank!"
        }
        else if password.count == 0
        {
            error_exist = true;
            self.Error_Info.text = "Password cannot be blank!"
        }
        if !error_exist
        {
//            var info_back: Array<Dictionary<String, AnyObject>>?
            // Send HTTP Request
            let json: [String: Any] =
            [
                "username": username,
                "password": password
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            let url = URL(string: "https://csci201.herokuapp.com/verify_password")!
            //let url = URL(string: "http://localhost:8080/CSCI201_Final/verify_password")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            //let test : String = ""
            //var information : String = ""
            var information : Array<Dictionary<String, AnyObject>>?
            let task = URLSession.shared.dataTask(with: request)
            {
                data, response, error in
                guard let data = data, error == nil
                else
                {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                //var test = String(decoding: data, as: UTF8.self)
                DispatchQueue.main.async
                {
                    //print("test: " + test)
                    //print(data)
                    information = self.convertJsonDataToDictionary(data)
                    let someVar : String = information![0]["info"] as! String
                    //Display login_related errors
                    if someVar == "login success"
                    {
                        //print(1)
                        LoggedInUser = username
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let ViewController = storyBoard.instantiateViewController(withIdentifier: "main")
                        self.present(ViewController, animated: true, completion: nil)
                    }
                    else if someVar == "username doesn't exist"
                    {
                        //print(2)
                        //self.Error_Info.text = "Username doesn't exist!"
                        
                        //make alert controller to display error message
                        let alert = UIAlertController(title: "Username doesn't exist!", message: "Please enter a valid username", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                        
                        
                    }
                    else if someVar == "wrong password"
                    {
                        //print(3)
                        //self.Error_Info.text = "Username and Password does not match!"
                        
                        //make alert controller to display error message
                        let alert = UIAlertController(title: "Username and Password do not match!", message: "Please enter a valid username/password combination", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                        
                    }
                }
//
            }
            task.resume()
        }
    }
}
