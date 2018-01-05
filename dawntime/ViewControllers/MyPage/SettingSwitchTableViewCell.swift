//
//  SettingSwitchTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 05/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class SettingSwitchTableViewCell: UITableViewCell {
    var delegate: LockSettingProtocol?
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
            } else {
                dic![menuLabel.text!] = true
            }
        } else {
            dic![menuLabel.text!] = false
        }
        NSDictionary(dictionary: dic!).write(toFile: path, atomically: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
