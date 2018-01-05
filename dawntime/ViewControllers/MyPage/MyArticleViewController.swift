//
//  MyArticleViewController.swift
//  dawntime
//
//  Created by PW486 on 04/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class MyArticleViewController: UIViewController {
//    var articles: [Article]?
//    var replies: [Reply]?
    var trueArticleFalseReply = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myArticleCountView: UIView!
    @IBOutlet weak var articleCountLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    
    @IBAction func viewArticleList(_ sender: Any) {
        print("글")
        trueArticleFalseReply = true
        articleCountLabel.textColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        articleLabel.textColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        replyCountLabel.textColor = UIColor.hexStringToUIColor(hex: "#B9BCCB")
        replyLabel.textColor = UIColor.hexStringToUIColor(hex: "#B9BCCB")
        tableView.reloadData()
    }
    
    @IBAction func viewReplyList(_ sender: Any) {
        print("댓글")
        trueArticleFalseReply = false
        articleCountLabel.textColor = UIColor.hexStringToUIColor(hex: "#B9BCCB")
        articleLabel.textColor = UIColor.hexStringToUIColor(hex: "#B9BCCB")
        replyCountLabel.textColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        replyLabel.textColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myArticleCountView.addBottomBorderWithColor(color: tableView.separatorColor!, width: 0.5)
        viewArticleList(UIView())
        
        self.tableView.register(UINib(nibName: CommunityArticleTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CommunityArticleTableViewCell.reuseIdentifier)
        self.tableView.register(UINib(nibName: MyPageReplyTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MyPageReplyTableViewCell.reuseIdentifier)
        // 사용자 글과 댓글 가져오기
    }
}

extension MyArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if trueArticleFalseReply {
//            return articles.count
//        } else {
//            return replies.count
//        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if trueArticleFalseReply {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommunityArticleTableViewCell.reuseIdentifier) as! CommunityArticleTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageReplyTableViewCell.reuseIdentifier) as! MyPageReplyTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
