//
//  NotificationViewController.swift
//  Test
//
//  Created by David on 3/27/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

struct ChatMessage
{
    let text: String
    let isIncoming: Bool
    let date: Date
}

//struct chatstruct {
//    enum CHAT: String {
//        case chats
//    }
//
//    let chats: [individualchat]
//}
//
//struct individualchat
//{
//    let Receiver: String
//    let Sender: String
//    let Date: String
//    let Body: String
//}

extension Date
{
    static func dateCustomeString (custromString: String) -> Date
    {
        return Date()
    }
}

class NotificationViewController: UITableViewController, UITextFieldDelegate {
    fileprivate let cellId = "id123"
    @IBOutlet var TextInput: UITextField!
    var chat_user : String = ""
    
    var chatMessages: [[ChatMessage]] =
    [
//        [
//            ChatMessage(text: "Here's my first message", isIncoming: true, date: Date.dateCustomeString(custromString: "")),
//            ChatMessage(text: "This is a extremely long line that should be able to get to the second line or even the third line1", isIncoming: false, date: Date.dateCustomeString(custromString: "")),
//            ChatMessage(text: "This is a extremely long line that should be able to get to the second line or even the third line2", isIncoming: true, date: Date.dateCustomeString(custromString: "")),
//        ],
//        [
//            ChatMessage(text:  "This is a extremely long line that should be able to get to the second line or even the third line3", isIncoming: true, date: Date.dateCustomeString(custromString: "")),
//            ChatMessage(text: "This is a extremely long line that should be able to get to the second line or even the third line4", isIncoming: true, date: Date.dateCustomeString(custromString: "")),
//            ChatMessage(text: "I sent this message out", isIncoming: false, date: Date.dateCustomeString(custromString: "")),
//        ]
    ]
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performAction()
        return true
    }
    
    func performAction() {
        var MessageSent1 : String = ""
        if (TextInput.text != nil)
        {
            MessageSent1 = TextInput.text ?? ""
            TextInput.text = ""
//            var Section : Int = 0
//            var stop : Bool = false
//            for block in chatMessages
//            {
//                for message in block
//                {
//                    //print (message.date)
//                    let difference = Date().timeIntervalSince(message.date)
//                    //print(difference)
//                    if difference < 1
//                    {
//                        stop = true
//                        break
//                    }
//                }
//                if (stop)
//                {
//                    break
//                }
//                Section = Section + 1
//            }
//            if stop
//            {
//                chatMessages[Section].append(ChatMessage(text: MessageSent1, isIncoming: false, date: Date.dateCustomeString(custromString: "")))
//            }
//            else
//            {
//                chatMessages.append([ChatMessage(text: MessageSent1, isIncoming: false, date: Date.dateCustomeString(custromString: ""))])
//            }
//            tableView.reloadData()
            var formattor = DateFormatter()
            formattor.dateFormat = "yyyy-MM-dd HH:mm"
            // Send message to backend
            var dater : String = formattor.string(from: Date())
            //print("Dater is now: " + dater)
            let json: [String: Any] =
            [
                "Sender": LoggedInUser,
                "Receiver": chat_user,
                "Body": MessageSent1,
                "Date": dater
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            let url = URL(string: "https://csci201.herokuapp.com/send_chat")!
            //let url = URL(string: "http://localhost:8080/CSCI201_Final/send_chat")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            //let test : String = ""
            //var information : String = ""
            let task = URLSession.shared.dataTask(with: request)
            {
                data, response, error in
                guard let _ = data, error == nil
                    else
                {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
            }
            task.resume()
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatMessages = []
        pullChat()
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            //self.chatMessages = []
            self.pullChat()
            print (self.chatMessages.count)
            self.tableView.reloadData()
        })
        self.navigationItem.title = "Messages"
        self.TextInput.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(BubbleTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        //print ("chat_user: " + chat_user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        pullChat()
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            //self.chatMessages = []
            self.pullChat()
            print (self.chatMessages.count)
            self.tableView.reloadData()
        })
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return chatMessages.count;
    }
    
    class DateHeaderLabel: UILabel
    {
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.8)
            textColor = .white
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false // enables auto layout
            font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder: has not been implemented)")
        }
        
        override var intrinsicContentSize: CGSize
        {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 16, height: height)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = chatMessages[section].first
        {
            let dateFormattor = DateFormatter()
            dateFormattor.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = dateFormattor.string(from: firstMessageInSection.date)
        
            let label = DateHeaderLabel()
            
            label.text = dateString
            
            let containerView = UIView()
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            return containerView
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return chatMessages[section].count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BubbleTableViewCell
        let chatMessage = chatMessages[indexPath.section][indexPath.row]
        cell.chatMessage = chatMessage
        cell.selectionStyle = .none
        //print(chatMessage.text)
        return cell
    }
    
    func pullChat()
    {
        let json: [String: Any] =
        [
            "LoggedInUser": LoggedInUser,
            "Aim": chat_user
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "https://csci201.herokuapp.com/pull_chat")!
        //let url = URL(string: "http://localhost:8080/CSCI201_Final/pull_chat")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        //let test : String = ""
        //var information : String = ""
        var information : Array<[String:AnyObject]>?
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil
                else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            DispatchQueue.main.async {
                //print (data)
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                //print(json)
                if let dictionary = json as? [String: Any] {
                    if let array = dictionary["chats"] as? [Any] {
                        //print (array.first)
                        for item in array{
                            if let dictionary2 = item as? [String: Any] {
                                var Sender: String = dictionary2["Sender"] as! String
                                var Receiver: String = dictionary2["Receiver"] as! String
                                var date: String = dictionary2["Date"] as! String
                                var Body: String = dictionary2["Body"] as! String
                                //print (Body)
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                let Date = dateFormatter.date(from: date)!
                                //temp_day = Date
                                var temp_message: ChatMessage
                                //print("Sender:" + Sender)
                                //print("LoggedInUser: " + LoggedInUser)
                                if (Sender == LoggedInUser)
                                {
                                    temp_message = ChatMessage(text: Body, isIncoming: false, date: Date)
                                }
                                else
                                {
                                    temp_message = ChatMessage(text: Body, isIncoming: true, date: Date)
                                }
                                self.InsertMessage(message: temp_message)
                                //print (Body)
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func InsertMessage(message: ChatMessage)
    {
        //print (message.text)
        var exist: Bool = false
        for item in chatMessages
        {
            for stuff in item
            {
                if stuff.date == message.date && stuff.text == message.text
                {
                    exist = true
                }
            }
        }
        if (!exist)
        {
            //print ("Trying to append")
            chatMessages.append([message])
        }
        
//        if (chatMessages.count == 0)
//        {
//            chatMessages.append([ChatMessage])
//        }
//        else
//        {
//            var temp_day: Date = (chatMessages[chatMessages.count-1] as AnyObject).date
//            if (ChatMessage.date-temp_day >= 1)
//            {
//                chatMessages.append([ChatMessage].self)
//            }
//            else
//            {
//                chatMessages[chatMessages.count-1].append(ChatMessage)
//            }
//        }
    }
}
