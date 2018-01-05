//
//  LockSettingViewController.swift
//  dawntime
//
//  Created by PW486 on 05/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LockSettingViewController: UIViewController {
    let keychainWrapper = KeychainWrapper.standard
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    var password: String = ""
    var inputPass: String = ""
    var checkPass: String = ""
    var trueUnLockfalseSetLock: Bool?
    
    @IBOutlet weak var InfoLabel: UILabel!
    @IBOutlet weak var lockKey1: UIView!
    @IBOutlet weak var lockKey2: UIView!
    @IBOutlet weak var lockKey3: UIView!
    @IBOutlet weak var lockKey4: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func numKeyAction(_ sender: UIButton) {
        inputPass += "\(sender.tag)"
        switch inputPass.count {
        case 1:
            roundCircleFill(lockKey1)
        case 2:
            roundCircleFill(lockKey2)
        case 3:
            roundCircleFill(lockKey3)
        case 4:
            roundCircleFill(lockKey4)
            if trueUnLockfalseSetLock! {
                if password == inputPass {
                    dismiss(animated: true, completion: nil)
                } else {
                    InfoLabel.text = "암호가 일치하지 않습니다"
                    inputPass = ""
                    resetLockKeys()
                }
            } else {
                if checkPass == "" {
                    InfoLabel.text = "암호 재입력하기"
                    checkPass = inputPass
                    inputPass = ""
                    resetLockKeys()
                } else if checkPass == inputPass {
                    keychainWrapper.set(checkPass, forKey: "LockPass")
                    
                    let path = documentDirectory.appending("/Setting.plist")
                    var dic = NSDictionary(contentsOfFile: path) as? [String: Bool]
                    dic!["잠금"] = true
                    NSDictionary(dictionary: dic!).write(toFile: path, atomically: true)
                    
                    dismiss(animated: true, completion: nil)
                } else {
                    InfoLabel.text = "암호가 일치하지 않습니다"
                    inputPass = ""
                    resetLockKeys()
                }
            }
        default:
            print("Defalut")
        }
    }
    
    @IBAction func eraseAction(_ sender: Any) {
        if inputPass != "" {
            inputPass.remove(at: inputPass.index(before: inputPass.endIndex))
        }
        switch inputPass.count {
        case 0:
            roundCircle(lockKey1)
        case 1:
            roundCircle(lockKey2)
        case 2:
            roundCircle(lockKey3)
        default:
            print("Defalut")
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        if !trueUnLockfalseSetLock! {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func resetLockKeys() {
        roundCircle(lockKey1)
        roundCircle(lockKey2)
        roundCircle(lockKey3)
        roundCircle(lockKey4)
    }
    
    func roundCircle(_ view: UIView) {
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = nil
    }
    
    func roundCircleFill(_ view: UIView) {
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = documentDirectory.appending("/Setting.plist")
        var dic = NSDictionary(contentsOfFile: path) as? [String: Bool]
        
        if dic!["잠금"] == true {
            // 잠금 풀기
            InfoLabel.text = "암호 입력하기"
            trueUnLockfalseSetLock = true
            cancelButton.setTitle("", for: .normal)
            cancelButton.isEnabled = false
            password = keychainWrapper.string(forKey: "LockPass")!
        } else {
            // 잠금 설정
            InfoLabel.text = "암호 입력하기"
            trueUnLockfalseSetLock = false
        }
        resetLockKeys()
    }
}
