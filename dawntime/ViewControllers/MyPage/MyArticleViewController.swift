//
//  MyArticleViewController.swift
//  dawntime
//
//  Created by PW486 on 04/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class MyArticleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myArticleCountView: UIView!
    @IBOutlet weak var articleCountLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    
    @IBAction func viewArticleList(_ sender: Any) {
        print("글")
    }
    
    @IBAction func viewReplyList(_ sender: Any) {
        print("댓글")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myArticleCountView.addBottomBorderWithColor(color: tableView.separatorColor!, width: 0.5)
    }
}

extension MyArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityArticleTableViewCell.reuseIdentifier) as! CommunityArticleTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
