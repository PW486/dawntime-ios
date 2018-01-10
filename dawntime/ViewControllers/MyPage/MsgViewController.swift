//
//  MsgViewController.swift
//  dawntime
//
//  Created by PW486 on 04/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MsgViewController: BaseViewController {
    var messages = [Message]()

    @IBOutlet weak var tableView: UITableView!
    
    func reloadDatas() {
        var newMessages = [Message]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request("http://13.125.78.152:6789/message/list", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        for (_, subJson):(String, JSON) in json["result"] {
                            do {
                                let message = try decoder.decode(Message.self, from: subJson.rawData())
                                newMessages.append(message)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.messages = newMessages
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    @objc func startReloadTableView(_ sender: UIRefreshControl) {
        reloadDatas()
        sender.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadDatas()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "쪽지함"
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
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(startReloadTableView), for: .valueChanged)
        
        reloadDatas()
    }
}

extension MsgViewController: UIGestureRecognizerDelegate {}

extension MsgViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: MsgDetailViewController.reuseIdentifier) as? MsgDetailViewController else { return }
        vc.message = messages[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MsgTableViewCell.reuseIdentifier, for: indexPath) as! MsgTableViewCell
        cell.message = messages[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
