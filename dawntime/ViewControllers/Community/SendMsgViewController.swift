//
//  SendMsgViewController.swift
//  dawntime
//
//  Created by PW486 on 10/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SendMsgViewController: BaseViewController {
    var article: Article?

    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendAction(_ sender: Any) {
        if let userToken = defaults.string(forKey: "userToken"), let boardID = article?.board_id, let content = contentField.text {
            let params = ["board_id": boardID, "msg_content": content] as [String : Any]
            Alamofire.request("http://13.125.78.152:6789/message/boardWrite", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    self.backAction()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "쪽지보내기"
        label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 18)
        label.textColor = UIColor.hexStringToUIColor(hex: "#001960")
        self.navigationItem.titleView = label
        
        contentField.text = "쪽지 내용을 써주세요."
        contentField.textColor = UIColor.lightGray
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        contentField.delegate = self
        contentField.textContainerInset = UIEdgeInsetsMake(7, 4, 7, 4)
        
        roundView(contentField, hex: "#868686", radius: 10, width: 0.5)
        roundView(sendButton, hex: "#0E1949", radius: 10, width: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
}

extension SendMsgViewController: UIGestureRecognizerDelegate {}

extension SendMsgViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "쪽지 내용을 써주세요."
            textView.textColor = UIColor.lightGray
        }
    }
}
