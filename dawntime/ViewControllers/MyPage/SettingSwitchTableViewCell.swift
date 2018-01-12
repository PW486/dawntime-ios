//
//  SettingSwitchTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 05/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingSwitchTableViewCell: UITableViewCell {
    var delegate: LockSettingProtocol?
    let defaults = UserDefaults.standard
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuInfoLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    @IBAction func switchAction(_ sender: Any) {
        let path = documentDirectory.appending("/Setting.plist")
        var dic = NSDictionary(contentsOfFile: path) as? [String: Bool]
        
        if switchButton.isOn {
            if menuLabel.text == "잠금" {
                delegate?.GoToLockSetting()
            } else if menuLabel.text == "블라인드" {
                putBlind()
                dic![menuLabel.text!] = true
            } else {
                dic![menuLabel.text!] = true
            }
        } else {
            if menuLabel.text == "블라인드" {
                putBlind()
                dic![menuLabel.text!] = false
            } else {
                dic![menuLabel.text!] = false
            }
        }
        NSDictionary(dictionary: dic!).write(toFile: path, atomically: true)
    }
    
    func putBlind() {
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request("http://13.125.78.152:6789/mypage/blind", method: .put, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        print(json)
                    }
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
