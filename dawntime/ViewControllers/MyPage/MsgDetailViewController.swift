//
//  MsgDetailViewController.swift
//  dawntime
//
//  Created by PW486 on 10/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MsgDetailViewController: BaseViewController {
    var message: Message?
    var messages = [Message]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageFieldView: UIView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var bottomTableView: NSLayoutConstraint!
    
    func reloadDatas() {
        var newMessages = [Message]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken"), let roomID = message?.room_id {
            Alamofire.request("http://13.125.78.152:6789/message/room/\(roomID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        for (_, subJson):(String, JSON) in json["result"] {
                            do {
                                let message = try decoder.decode(Message.self, from: subJson.rawData())
                                newMessages.append(message)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.messages = newMessages
                    self.tableView.reloadData()
                    self.scrollToBottom()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    @IBAction func sendMessage() {
        if messageField.text != "" {
            if let userToken = defaults.string(forKey: "userToken"), let roomID = message?.room_id, let content = messageField.text {
                let params = ["room_id": roomID, "msg_content": content] as [String : Any]
                Alamofire.request("http://13.125.78.152:6789/message/write", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                    (res) in
                    switch res.result {
                    case .success:
                        self.messageField.text = ""
                        self.reloadDatas()
                        break
                    case .failure(let err):
                        print(err.localizedDescription)
                        break
                    }
                }
            }
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadDatas()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "쪽지"
        label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 18)
        label.textColor = UIColor.hexStringToUIColor(hex: "#001960")
        self.navigationItem.titleView = label
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        
        messageFieldView.addTopBorderWithColor(color: UIColor.lightGray, width: 0.5)
        roundView(messageField, hex: "#868686", radius: 10, width: 0.5)
        
        messageField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        messageField.leftViewMode = UITextFieldViewMode.always
        messageField.delegate = self
        
        setKeyBoardSetting()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tapGesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGesture)
        
        reloadDatas()
    }
}

extension MsgDetailViewController: UIGestureRecognizerDelegate {}

extension MsgDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].user_send! {
            let cell = tableView.dequeueReusableCell(withIdentifier: MsgDetailMeTableViewCell.reuseIdentifier, for: indexPath) as! MsgDetailMeTableViewCell
            cell.contentLabel.text = messages[indexPath.row].msg_content
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MsgDetailYouTableViewCell.reuseIdentifier, for: indexPath) as! MsgDetailYouTableViewCell
            cell.contentLabel.text = messages[indexPath.row].msg_content
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension MsgDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == messageField {
            sendMessage()
            return false
        }
        return true
    }
    
    func setKeyBoardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomTableView.constant = 57 + keyboardSize.height - self.tabBarController!.tabBar.frame.height
            
            if let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.bottomTableView.constant = 57
        
        if let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
