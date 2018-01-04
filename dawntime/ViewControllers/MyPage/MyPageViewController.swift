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
    
    var logInStatus = true
    var menus: [String] = ["내가 쓴 글", "스크랩", "쪽지", "찜 목록", "설정", ""]
    
    @IBAction func logInAction(_ sender: Any) {
        // 로그인 창으로 present, delegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if logInStatus {
            logInBtn.isHidden = true
            logInRequireLabel.isHidden = true
            emailLabel.text = "logIn@logIn.com"
            userImage.image = #imageLiteral(resourceName: "view_activeprofile_navy")
        }
        else {
            emailLabel.isHidden = true
            userImage.image = #imageLiteral(resourceName: "view_unactiveprofile_gray")
        }
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
        switch(indexPath.row) {
        case 0:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let vc = storyBoard.instantiateViewController(withIdentifier: MyArticleViewController.reuseIdentifier) as? MyArticleViewController else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("default")
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
