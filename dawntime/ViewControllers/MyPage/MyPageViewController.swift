//
//  MyPageViewController.swift
//  dawntime
//
//  Created by PW486 on 04/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var logInRequireLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    let defaults = UserDefaults.standard
    var logInStatus = false
    var menus: [String] = ["내가 쓴 글", "스크랩", "쪽지", "찜 목록", "설정", ""]
    
    @IBAction func logInAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: LogInViewController.reuseIdentifier) as? LogInViewController else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logInStatus = defaults.bool(forKey: "logInStatus")
        
        if logInStatus {
            logInBtn.isHidden = true
            logInRequireLabel.isHidden = true
            emailLabel.isHidden = false
            emailLabel.text = self.defaults.string(forKey: "userEmail")
            userImage.image = #imageLiteral(resourceName: "view_activeprofile_navy")
        }
        else {
            logInBtn.isHidden = false
            logInRequireLabel.isHidden = false
            emailLabel.isHidden = true
            emailLabel.text = ""
            userImage.image = #imageLiteral(resourceName: "view_unactiveprofile_gray")
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.addBottomBorderWithColor(color: self.tableView.separatorColor!, width: 1.0)
        
        // tableView Footer line
//        let px = 1 / UIScreen.main.scale
//        let frame = CGRect(x: 12, y: 0, width: self.tableView.frame.size.width - 36, height: px)
//        let line = UIView(frame: frame)
//        self.tableView.tableFooterView = line
//        line.backgroundColor = self.tableView.separatorColor
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if logInStatus {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            switch(indexPath.row) {
            case 0:
                guard let vc = storyBoard.instantiateViewController(withIdentifier: MyArticleViewController.reuseIdentifier) as? MyArticleViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                guard let vc = storyBoard.instantiateViewController(withIdentifier: MyScrapViewController.reuseIdentifier) as? MyScrapViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                print("Nothing")
//                guard let vc = storyBoard.instantiateViewController(withIdentifier: MsgViewController.reuseIdentifier) as? MsgViewController else { return }
//                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                print("Nothing")
//                guard let vc = storyBoard.instantiateViewController(withIdentifier: MyWishlistViewController.reuseIdentifier) as? MyWishlistViewController else { return }
//                self.navigationController?.pushViewController(vc, animated: true)
            case 4:
                guard let vc = storyBoard.instantiateViewController(withIdentifier: SettingViewController.reuseIdentifier) as? SettingViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                print("Default")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPageMenuTableViewCell.reuseIdentifier) as! MyPageMenuTableViewCell
        
        cell.selectionStyle = .none
        cell.menuLabel.text = menus[indexPath.row]
        if logInStatus && menus[indexPath.row] == "찜 목록" {
            cell.menuLabel.textColor = UIColor.hexStringToUIColor(hex: "#ED508E")
        }
        else if logInStatus {
            cell.menuLabel.textColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        }
        else {
            cell.menuLabel.textColor = UIColor.hexStringToUIColor(hex: "#B7B7B7")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
