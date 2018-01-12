//
//  MyArticleViewController.swift
//  dawntime
//
//  Created by PW486 on 04/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyArticleViewController: BaseViewController {
    var articles = [Article]() {
        didSet{
            self.tableView.reloadData()
        }
    }
    var comments = [Comment]() {
        didSet{
            self.tableView.reloadData()
        }
    }
    var trueArticleFalseComment = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myArticleCountView: UIView!
    @IBOutlet weak var articleCountLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    
    @IBAction func viewArticleList(_ sender: Any) {
        trueArticleFalseComment = true
        articleCountLabel.textColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        articleLabel.textColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        replyCountLabel.textColor = UIColor.hexStringToUIColor(hex: "#B9BCCB")
        replyLabel.textColor = UIColor.hexStringToUIColor(hex: "#B9BCCB")
        reloadDatas()
    }
    
    @IBAction func viewReplyList(_ sender: Any) {
        trueArticleFalseComment = false
        articleCountLabel.textColor = UIColor.hexStringToUIColor(hex: "#B9BCCB")
        articleLabel.textColor = UIColor.hexStringToUIColor(hex: "#B9BCCB")
        replyCountLabel.textColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        replyLabel.textColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        reloadDatas()
    }
    
    func reloadDatas() {
        let decoder = JSONDecoder()
        if trueArticleFalseComment {
            var newArticles = [Article]()
            if let userToken = defaults.string(forKey: "userToken") {
                Alamofire.request("http://13.125.78.152:6789/mypage/mypost", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                    (res) in
                    switch res.result {
                    case .success:
                        if let value = res.result.value {
                            let json = JSON(value)
                            if let articleCount = json["myPost_count"].int {
                                self.articleCountLabel.text = "\(articleCount)"
                            }
                            if let commentCount = json["myCom_count"].int {
                                self.replyCountLabel.text = "\(commentCount)"
                            }
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
                        break
                    case .failure(let err):
                        print(err.localizedDescription)
                        break
                    }
                }
            }
        } else {
            var newComments = [Comment]()
            if let userToken = defaults.string(forKey: "userToken") {
                Alamofire.request("http://13.125.78.152:6789/mypage/mycomment", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                    (res) in
                    switch res.result {
                    case .success:
                        if let value = res.result.value {
                            let json = JSON(value)
                            if let articleCount = json["myPost_count"].int {
                                self.articleCountLabel.text = "\(articleCount)"
                            }
                            if let commentCount = json["myCom_count"].int {
                                self.replyCountLabel.text = "\(commentCount)"
                            }
                            for (_, subJson):(String, JSON) in json["result"] {
                                do {
                                    let comment = try decoder.decode(Comment.self, from: subJson.rawData())
                                    newComments.append(comment)
                                }
                                catch {
                                    print(error)
                                }
                            }
                        }
                        self.comments = newComments
                        break
                    case .failure(let err):
                        print(err.localizedDescription)
                        break
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        reloadDatas()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myArticleCountView.addBottomBorderWithColor(color: tableView.separatorColor!, width: 0.5)
        viewArticleList(self)
        
        let label = UILabel()
        label.text = "내가 쓴 글"
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
        
        self.tableView.register(UINib(nibName: CommunityArticleTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CommunityArticleTableViewCell.reuseIdentifier)
        self.tableView.register(UINib(nibName: MyPageReplyTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MyPageReplyTableViewCell.reuseIdentifier)
    }
}

extension MyArticleViewController: UIGestureRecognizerDelegate {}

extension MyArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trueArticleFalseComment {
            return articles.count
        } else {
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if trueArticleFalseComment {
            guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadArticleViewController.reuseIdentifier) as? ReadArticleViewController else { return }
            vc.article = articles[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadArticleViewController.reuseIdentifier) as? ReadArticleViewController else { return }
            vc.article = Article()
            vc.article?.board_id = comments[indexPath.row].board_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if trueArticleFalseComment {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommunityArticleTableViewCell.reuseIdentifier) as! CommunityArticleTableViewCell
            cell.article = nil
            DispatchQueue.main.async {
                [weak self] in
                cell.article = self?.articles[indexPath.row]
                cell.selectionStyle = .none
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageReplyTableViewCell.reuseIdentifier) as! MyPageReplyTableViewCell
            cell.comment = nil
            DispatchQueue.main.async {
                [weak self] in
                cell.comment = self?.comments[indexPath.row]
                cell.selectionStyle = .none
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if trueArticleFalseComment {
            return 88
        } else {
            if comments[indexPath.row].board_image == nil {
                return 62
            } else {
                return 88
            }
        }
    }
}
