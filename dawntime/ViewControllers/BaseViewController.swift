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
    var categories = ["걱정", "리뷰", "추천", "애인", "팁", "썰", "질문", "기타", "자랑", "건의"]
    
    func dimBackground(_ view: UIView) {
        let border = CALayer()
        border.backgroundColor = UIColor.hexStringToUIColor(hex: "#0E1949").withAlphaComponent(0.4).cgColor
        border.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: UIScreen.main.bounds.size.height)
        view.layer.addSublayer(border)
        let border2 = CALayer()
        border2.backgroundColor = UIColor.hexStringToUIColor(hex: "#0E1949").withAlphaComponent(0.4).cgColor
        border2.frame = CGRect(x: 0, y: 0, width: (self.tabBarController?.tabBar.frame.size.width)!, height: (self.tabBarController?.tabBar.frame.size.height)!)
        self.tabBarController?.tabBar.layer.addSublayer(border2)
    }
    
    func eraseDimBackground(_ view: UIView) {
        view.layer.sublayers?.last?.removeFromSuperlayer()
        self.tabBarController?.tabBar.layer.sublayers?.last?.removeFromSuperlayer()
    }
    
    func roundView(_ view: UIView, hex: String, radius: CGFloat, width: CGFloat) {
        view.layer.borderWidth = width
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.hexStringToUIColor(hex: hex).cgColor
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
    }
    
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
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
