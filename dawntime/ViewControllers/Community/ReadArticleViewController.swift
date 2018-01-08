//
//  ReadArticleViewController.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Kingfisher

class ReadArticleViewController: UIViewController {
    var article: Article?
    var comments = [Comment]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @objc func moreMenu() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let writer_check = article?.writer_check, writer_check {
            let editAction: UIAlertAction = UIAlertAction(title: "글 수정", style: .default) { action -> Void in
                print("글 수정")
            }
            let delAction: UIAlertAction = UIAlertAction(title: "글 삭제", style: .default) { action -> Void in
                print("글 삭제")
            }
            actionSheetController.addAction(editAction)
            actionSheetController.addAction(delAction)
        } else {
            let msgAction: UIAlertAction = UIAlertAction(title: "쪽지 보내기", style: .default) { action -> Void in
                print("쪽지 보내기")
            }
            let feedbackAction: UIAlertAction = UIAlertAction(title: "글 신고", style: .destructive) { action -> Void in
                print("글 신고")
            }
            actionSheetController.addAction(msgAction)
            actionSheetController.addAction(feedbackAction)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel) { action -> Void in }
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_more_navy"), style: .done, target: self, action: #selector(moreMenu))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        // 글 상세보기 서버 통신
        comments.append(Comment(com_id: 1, com_parent: 0, com_seq: 1, com_date: "2018-1-1", com_content: "댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글", com_writer: 1, recom_check: false, writer_check: true))
        comments.append(Comment(com_id: 2, com_parent: 1, com_seq: 2, com_date: "2018-1-1", com_content: "댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글", com_writer: 0, recom_check: true, writer_check: false))
        comments.append(Comment(com_id: 3, com_parent: 0, com_seq: 1, com_date: "2018-1-1", com_content: "댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글", com_writer: 1, recom_check: false, writer_check: true))
        comments.append(Comment(com_id: 4, com_parent: 3, com_seq: 2, com_date: "2018-1-1", com_content: "댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글", com_writer: 0, recom_check: true, writer_check: false))
        comments.append(Comment(com_id: 5, com_parent: 0, com_seq: 1, com_date: "2018-1-1", com_content: "댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글", com_writer: 0, recom_check: false, writer_check: false))
    }
}

extension ReadArticleViewController: UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let imageCount = article?.board_image?.count ?? 0
        let comCount = article?.com_count ?? 0
        return 1 + imageCount + comCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReadArticleTableViewCell.reuseIdentifier) as! ReadArticleTableViewCell
            cell.article = self.article
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            cell.selectionStyle = .none
            return cell
        } else if let imageCount = article?.board_image?.count, imageCount >= indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReadArticleImageTableViewCell.reuseIdentifier) as! ReadArticleImageTableViewCell
            cell.articleImageView.kf.setImage(with: URL(string: (article?.board_image![indexPath.row-1])!), completionHandler: {
                (image, error, cacheType, imageUrl) in
                tableView.beginUpdates()
                tableView.endUpdates()
            })
            cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
            cell.selectionStyle = .none
            return cell
        } else {
            let imageCount = article?.board_image?.count ?? 0
            let comment = comments[(indexPath.row-1-imageCount) % 5] // comments[indexPath.row-1-imageCount]
            if let recom_check = comment.recom_check, recom_check {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReadArticleChildCommentTableViewCell.reuseIdentifier) as! ReadArticleChildCommentTableViewCell
                cell.comment = comment
                cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReadArticleCommentTableViewCell.reuseIdentifier) as! ReadArticleCommentTableViewCell
                cell.comment = comment
                cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
                cell.selectionStyle = .none
                return cell
            }
        }
    }
}
