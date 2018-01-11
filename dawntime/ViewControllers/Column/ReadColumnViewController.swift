//
//  ReadColumnViewController.swift
//  dawntime
//
//  Created by PW486 on 03/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

class ReadColumnViewController: BaseViewController {
    var column: Column?
    var columnImage = ""

    @IBOutlet weak var tableView: UITableView!
    
    func reloadDatas() {
        if let userToken = defaults.string(forKey: "userToken"), let columnID = column?.column_id {
            Alamofire.request("http://13.125.78.152:6789/column/detail/\(columnID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        if let img = json["result"].string {
                            self.columnImage = img
                        }
                    }
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
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
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        reloadDatas()
    }
}

extension ReadColumnViewController: UIGestureRecognizerDelegate {}

extension ReadColumnViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReadColumnTableViewCell.reuseIdentifier) as! ReadColumnTableViewCell
        cell.selectionStyle = .none
        cell.cardImage.kf.setImage(with: URL(string: columnImage), completionHandler: {
            (image, error, cacheType, imageUrl) in
            UIView.performWithoutAnimation({
                tableView.beginUpdates()
                tableView.endUpdates()
            })
        })
        return cell
    }
}
