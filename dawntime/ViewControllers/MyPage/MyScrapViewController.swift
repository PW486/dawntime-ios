//
//  MyScrapViewController.swift
//  dawntime
//
//  Created by PW486 on 04/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyScrapViewController: BaseViewController {
    var articles = [Article]()
    @IBOutlet weak var tableView: UITableView!
    
    func reloadDatas() {
        let decoder = JSONDecoder()
        var newArticles = [Article]()
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request("http://13.125.78.152:6789/mypage/boardScrapList", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        for (_, subJson):(String, JSON) in json["result"] {
                            do {
                                let article = try decoder.decode(Article.self, from: subJson.rawData())
                                newArticles.append(article)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.articles = newArticles
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
        tableView.delegate = self
        tableView.dataSource = self
        
        let label = UILabel()
        label.text = "스크랩"
        label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 18)
        label.textColor = UIColor.hexStringToUIColor(hex: "#001960")
        self.navigationItem.titleView = label
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.tableView.register(UINib(nibName: CommunityArticleTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CommunityArticleTableViewCell.reuseIdentifier)
        
        reloadDatas()
    }
}

extension MyScrapViewController: UIGestureRecognizerDelegate {}

extension MyScrapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadArticleViewController.reuseIdentifier) as? ReadArticleViewController else { return }
        vc.article = articles[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityArticleTableViewCell.reuseIdentifier) as! CommunityArticleTableViewCell
        cell.article = articles[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
