//
//  RegisterController.swift
//  Test
///Users/david/Desktop/Test/Test/RegisterController.swift
//  Created by David on 4/5/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var username_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var confirm_password_field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let number = Int.random(in: 1 ..< 10)
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = PickBackGround(stringIcon: String(number))
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func PickBackGround(stringIcon: String) -> UIImage {
        var imageName: String
        switch stringIcon {
        case "1":
            imageName = "akshat-vats-735607-unsplash"
        case "2":
            imageName = "ben-dove-508756-unsplash"
        case "3":
            imageName = "jose-carbajal-1131071-unsplash"
        case "4":
            imageName = "juskteez-vu-1041-unsplash"
        case "5":
            imageName = "luke-stackpoole-571003-unsplash"
        case "6":
            imageName = "ruben-gutierrez-1385312-unsplash"
        case "7":
            imageName = "sina-katirachi-1342186-unsplash"
        case "8":
            imageName = "taylor-simpson-1385357-unsplash"
        case "9":
            imageName = "taylor-simpson-1417427-unsplash"
        default:
            imageName = "jordan-bowman-566225-unsplash"
        }
        let ReturnImage = UIImage(named: imageName)
        return ReturnImage!
    }
    
    @IBAction func Register_Click(_ sender: UIButton)
    {
        let username: String = self.username_field.text ?? ""
        let password: String = self.password_field.text ?? ""
        let confirm_password: String = self.confirm_password_field.text ?? ""
        var error_exist: Bool = false;
        if username.count == 0
        {
            error_exist = true;
            self.error.text = "Username cannot be blank!"
        }
        else if password.count == 0
        {
            error_exist = true;
            self.error.text = "Password cannot be blank!"
        }
        else if password != confirm_password
        {
            error_exist = true;
            self.error.text = "Password does not match!"
        }
        if !error_exist
        {
            // Send HTTP Request
            let json: [String: Any] =
            [
                "username": username,
                "password": password
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            let url = URL(string: "https://csci201.herokuapp.com/Register")!
            //let url = URL(string: "http://localhost:8080/CSCI201_Final/Register")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            var test = ""
            
            
            let workQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
            workQueue.sync {
                let task = URLSession.shared.dataTask(with: request)
                {
                    data, response, error in
                    guard let data = data, error == nil
                        else
                    {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                    test = String(decoding: data, as: UTF8.self)
                    DispatchQueue.main.async
                        {
                            print(test)
                            //Display login_related errors
                            if test == "{\"info\": \"Register Succeed!\"}"
                            {
                                LoggedInUser = username
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let ViewController = storyBoard.instantiateViewController(withIdentifier: "main")
                                self.present(ViewController, animated: true, completion: nil)
                            }
                            else if test == "{\"info\": \"This username is already taken\"}"
                            {
                                self.error.text = "This username is already taken!"
                                
                                
                            }
//                            else if test == "{info: \"password length\"}"
//                            {
//                                print(3)
//                                self.error.text = "Password need to be 6 to 14 characters!"
//                            }
                    }
                    //                info_back = self.convertJsonStringToDictionary(test)
                }
                task.resume()
            }
        }
    }
}
