//
//  MyPageViewController.swift
//  dawntime
//
//  Created by PW486 on 04/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {
    var menus: [String] = ["내가 쓴 글", "스크랩", "쪽지", "찜 목록", "설정"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 프로필 부분 셀 말고 따로 빼기
        switch(indexPath.row) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageProfileTableViewCell.reuseIdentifier) as! MyPageProfileTableViewCell
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageMenuTableViewCell.reuseIdentifier) as! MyPageMenuTableViewCell
            cell.menuLabel.text = menus[indexPath.row]
            return cell
        }
    }
    
    
}
