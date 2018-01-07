//
//  BaseViewController.swift
//  dawntime
//
//  Created by PW486 on 07/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class BaseViewController: UIViewController {
    let defaults = UserDefaults.standard
    let fileManager = FileManager.default
    let keychainWrapper = KeychainWrapper.standard
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

    @objc func initSettingAndCheckLock() {
        let path = documentDirectory.appending("/Setting.plist")
        if(!fileManager.fileExists(atPath: path)){
            let data : [String: Bool] = [
                "알림": false,
                "잠금": false,
                "블라인드": false
            ]
            NSDictionary(dictionary: data).write(toFile: path, atomically: true)
            defaults.set(false, forKey: "logInStatus")
        }
        
        var dic = NSDictionary(contentsOfFile: path) as? [String: Bool]
        
        if dic!["잠금"] == true {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: LockSettingViewController.reuseIdentifier) as? LockSettingViewController else { return }
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
