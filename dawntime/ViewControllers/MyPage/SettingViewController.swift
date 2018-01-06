//
//  SettingViewController.swift
//  dawntime
//
//  Created by PW486 on 04/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

protocol LockSettingProtocol {
    func GoToLockSetting()
}

class SettingViewController: UIViewController {
    let defaults = UserDefaults.standard
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    // SettingLabelText, Switch, InfoLabelTrue, InfoLabelText
    let settinglist: [(String, Bool, Bool, String)] = [("알림", true, false, ""),("잠금", true, false, ""),("블라인드", true, true, "홈 화면의 베스트 상품 사진을 필터링 합니다."),("로그아웃", false, false, ""),("회원탈퇴", false, false, "")]
    
    @IBOutlet weak var tableView: UITableView!
    
    func logOut() {
        defaults.set(false, forKey: "logInStatus")
        defaults.removeObject(forKey: "userID")
        defaults.removeObject(forKey: "userEmail")
        
        let path = documentDirectory.appending("/Setting.plist")
        let data : [String: Bool] = [
            "알림": false,
            "잠금": false,
            "블라인드": false
        ]
        NSDictionary(dictionary: data).write(toFile: path, atomically: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SettingViewController: LockSettingProtocol {
    func GoToLockSetting() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: LockSettingViewController.reuseIdentifier) as? LockSettingViewController else { return }
        self.present(vc, animated: true, completion: nil)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settinglist.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 3:
            logOut()
        case 4:
            // Delete Account
            logOut()
        default:
            print("Default")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if settinglist[indexPath.row].1 == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingSwitchTableViewCell.reuseIdentifier) as! SettingSwitchTableViewCell
            cell.delegate = self
            cell.menuLabel.text = settinglist[indexPath.row].0
            cell.menuLabel.textColor = UIColor.hexStringToUIColor(hex: "#4F4F4F")
            if settinglist[indexPath.row].2 == false {
                cell.menuInfoLabel.isHidden = true
            } else {
                cell.menuInfoLabel.text = settinglist[indexPath.row].3
                cell.menuInfoLabel.textColor = UIColor.hexStringToUIColor(hex: "#A8A8A8")
            }
            
            let path = documentDirectory.appending("/Setting.plist")
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Bool] {
                cell.switchButton.isOn = dic[settinglist[indexPath.row].0]!
            }
            
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageMenuTableViewCell.reuseIdentifier) as! MyPageMenuTableViewCell
            cell.menuLabel.text = settinglist[indexPath.row].0
            cell.menuLabel.textColor = UIColor.hexStringToUIColor(hex: "#4F4F4F")
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
