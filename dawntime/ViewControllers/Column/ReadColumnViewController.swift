//
//  ReadColumnViewController.swift
//  dawntime
//
//  Created by PW486 on 03/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Kingfisher

class ReadColumnViewController: UIViewController {
    var column: Column?
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "칼럼"
        label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 18)
        label.textColor = UIColor.hexStringToUIColor(hex: "#001960")
        self.navigationItem.titleView = label
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // 칼럼 상세보기 서버 통신
    }
}

extension ReadColumnViewController: UIGestureRecognizerDelegate {}

extension ReadColumnViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (column?.column_image?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReadColumnTableViewCell.reuseIdentifier) as! ReadColumnTableViewCell
        cell.selectionStyle = .none
        cell.cardImage.kf.setImage(with: URL(string: (column?.column_image![indexPath.row])!))
        return cell
    }
}
