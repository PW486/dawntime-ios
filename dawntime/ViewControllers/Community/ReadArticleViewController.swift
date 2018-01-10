//
//  ReadArticleViewController.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON
import Lightbox

class ReadArticleViewController: BaseViewController {
    var article: Article?
    var comments = [Comment]()
    var parentComment: Comment?
    var isRecomment = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentFieldView: UIView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var bottomTableView: NSLayoutConstraint!
    
    @IBAction func fireTapAction(_ sender: Any) {
        if let userToken = defaults.string(forKey: "userToken"), let boardID = article?.board_id {
            Alamofire.request("http://13.125.78.152:6789/board/like/\(boardID)", method: .put, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        if let msg = json["message"].string {
                            if msg == "successful like" {
                                self.article?.user_like = true
                                if let count = self.article?.board_like {
                                    self.article?.board_like = count + 1
                                }
                            } else if msg == "successful unlike" {
                                self.article?.user_like = false
                                if let count = self.article?.board_like {
                                    self.article?.board_like = count - 1
                                }
                            }
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
    
    @IBAction func scrapTapAction(_ sender: Any) {
        if let userToken = defaults.string(forKey: "userToken"), let boardID = article?.board_id {
            Alamofire.request("http://13.125.78.152:6789/board/scrap", method: .put, parameters: ["board_id": boardID], encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        if let msg = json["message"].string {
                            if msg == "successfully registered scrap" {
                                self.article?.user_scrap = true
                                if let count = self.article?.scrap_count {
                                    self.article?.scrap_count = count + 1
                                }
                            } else if msg == "successfully deleted scrap" {
                                self.article?.user_scrap = false
                                if let count = self.article?.scrap_count {
                                    self.article?.scrap_count = count - 1
                                }
                            }
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
    
    @IBAction func sendAction(_ sender: Any) {
        if isRecomment == true {
            if parentComment?.com_parent == 0 {
                sendComment(com_parent: (parentComment?.com_id)!)
            } else {
                sendComment(com_parent: (parentComment?.com_parent)!)
            }
            isRecomment = false
        } else {
            sendComment(com_parent: 0)
        }
    }
    
    func reloadDatas() {
        var newArticle = Article()
        var newComments = [Comment]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken"), let boardID = article?.board_id {
            Alamofire.request("http://13.125.78.152:6789/board/list/\(boardID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        do {
                            newArticle = try decoder.decode(Article.self, from: json["boardResult"][0].rawData())
                        }
                        catch {
                            print(error)
                        }
                        for (_, subJson):(String, JSON) in json["comResult"] {
                            do {
                                let comment = try decoder.decode(Comment.self, from: subJson.rawData())
                                newComments.append(comment)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.article = newArticle
                    self.comments = newComments
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    func deleteArticle() {
        if let userToken = defaults.string(forKey: "userToken"), let boardID = article?.board_id {
            Alamofire.request("http://13.125.78.152:6789/board/delete", method: .delete, parameters: ["board_id": boardID], encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    self.backAction()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    func sendComment(com_parent: Int) {
        if let userToken = defaults.string(forKey: "userToken"), let boardID = article?.board_id, let content = commentField.text {
            let params = ["board_id": boardID, "com_parent": "\(com_parent)", "com_content": content] as [String : Any]
            Alamofire.request("http://13.125.78.152:6789/comment/write", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    self.commentField.text = ""
                    self.dismissKeyBoard()
                    self.reloadDatas()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    func deleteCommnet() {
        if let userToken = defaults.string(forKey: "userToken"), let comID = parentComment?.com_id {
            Alamofire.request("http://13.125.78.152:6789/comment/delete", method: .delete, parameters: ["com_id": comID], encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    self.reloadDatas()
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
    
    @objc func moreMenu() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let writer_check = article?.writer_check, writer_check {
            let editAction: UIAlertAction = UIAlertAction(title: "글 수정", style: .default) { action -> Void in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: CreateUpdateArticleViewController.reuseIdentifier) as? CreateUpdateArticleViewController else { return }
                vc.article = self.article
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let delAction: UIAlertAction = UIAlertAction(title: "글 삭제", style: .default) { action -> Void in
                let alert = UIAlertController(title: "글 삭제", message: "정말로 글을 삭제하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in self.deleteArticle() }))
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                alert.view.tintColor = UIColor.hexStringToUIColor(hex: "#0E1949")
                self.present(alert, animated: true, completion: nil)
            }
            actionSheetController.addAction(editAction)
            actionSheetController.addAction(delAction)
        } else {
            let msgAction: UIAlertAction = UIAlertAction(title: "쪽지 보내기", style: .default) { action -> Void in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: SendMsgViewController.reuseIdentifier) as? SendMsgViewController else { return }
                vc.article = self.article
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let feedbackAction: UIAlertAction = UIAlertAction(title: "글 신고", style: .destructive) { action -> Void in
                self.showToast("신고 접수되었습니다.")
            }
            actionSheetController.addAction(msgAction)
            actionSheetController.addAction(feedbackAction)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel) { action -> Void in }
        actionSheetController.addAction(cancelAction)
        actionSheetController.view.tintColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func commentMoreMenu(_ cell: UITableViewCell) {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let recommentAction: UIAlertAction = UIAlertAction(title: "대댓글 달기", style: .default) { action -> Void in
            self.isRecomment = true
            self.commentField.becomeFirstResponder()
        }
        actionSheetController.addAction(recommentAction)
        
        if let writer_check = parentComment?.writer_check, writer_check {
            let delAction: UIAlertAction = UIAlertAction(title: "댓글 삭제", style: .default) { action -> Void in
                self.deleteCommnet()
            }
            actionSheetController.addAction(delAction)
        } else {
            /* let msgAction: UIAlertAction = UIAlertAction(title: "쪽지 보내기", style: .default) { action -> Void in
                print("쪽지 보내기")
                cell.contentView.backgroundColor = UIColor.white
            }
            actionSheetController.addAction(msgAction) */
            let feedbackAction: UIAlertAction = UIAlertAction(title: "신고", style: .destructive) { action -> Void in
                self.showToast("신고 접수되었습니다.")
                cell.contentView.backgroundColor = UIColor.white
            }
            actionSheetController.addAction(feedbackAction)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel) { action -> Void in
            cell.contentView.backgroundColor = UIColor.white
        }
        actionSheetController.addAction(cancelAction)
        actionSheetController.view.tintColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadDatas()
        let img = UIImage()
        self.tabBarController?.tabBar.shadowImage = img
        self.tabBarController?.tabBar.backgroundImage = img
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.shadowImage = nil
        self.tabBarController?.tabBar.backgroundImage = nil
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
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(startReloadTableView), for: .valueChanged)
        
        commentFieldView.addTopBorderWithColor(color: UIColor.lightGray, width: 0.5)
        roundView(commentField, hex: "#0E1949", radius: 15, width: 0.0)
        
        commentField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        commentField.leftViewMode = UITextFieldViewMode.always
        commentField.delegate = self
        
        setKeyBoardSetting()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tapGesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGesture)
        
        reloadDatas()
    }
}

extension ReadArticleViewController: UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let imageCount = article?.board_images?.count ?? 0
        let comCount = comments.count
        return 1 + imageCount + comCount
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) is ReadArticleImageTableViewCell {
            var imageList = [LightboxImage]()
            if let boardImages = article?.board_images {
                for img in boardImages {
                    imageList.append(LightboxImage(imageURL: URL(string: img)!))
                }
            }
            let controller = LightboxController(images: imageList)
            controller.dynamicBackground = true
            controller.goTo(indexPath.row-1, animated: false)
            
            present(controller, animated: true, completion: nil)
        } else if let cell = tableView.cellForRow(at: indexPath), cell is ReadArticleCommentTableViewCell || cell is ReadArticleChildCommentTableViewCell {
            isRecomment = false
            if cell.contentView.backgroundColor != UIColor.hexStringToUIColor(hex: "#0E1949").withAlphaComponent(0.2) {
                cell.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: "#0E1949").withAlphaComponent(0.2)
                let imageCount = article?.board_images?.count ?? 0
                parentComment = comments[indexPath.row-1-imageCount]
                commentMoreMenu(cell)
            } else {
                cell.contentView.backgroundColor = UIColor.white
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), cell is ReadArticleCommentTableViewCell || cell is ReadArticleChildCommentTableViewCell {
            cell.contentView.backgroundColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReadArticleTableViewCell.reuseIdentifier) as! ReadArticleTableViewCell
            cell.article = self.article
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            cell.selectionStyle = .none
            return cell
        } else if let imageCount = article?.board_images?.count, imageCount >= indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReadArticleImageTableViewCell.reuseIdentifier) as! ReadArticleImageTableViewCell
            cell.articleImageView.kf.setImage(with: URL(string: (article?.board_images![indexPath.row-1])!), completionHandler: {
                (image, error, cacheType, imageUrl) in
                UIView.performWithoutAnimation({
                    tableView.beginUpdates()
                    tableView.endUpdates()
                })
            })
            cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
            cell.selectionStyle = .none
            return cell
        } else {
            let imageCount = article?.board_images?.count ?? 0
            let comment = comments[indexPath.row-1-imageCount]
            if let recom_check = comment.recom_check, recom_check {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReadArticleCommentTableViewCell.reuseIdentifier) as! ReadArticleCommentTableViewCell
                cell.comment = comment
                cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
                cell.selectionStyle = .none
                if isRecomment && parentComment?.com_id == comment.com_id {
                    cell.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: "#0E1949").withAlphaComponent(0.2)
                } else {
                    cell.contentView.backgroundColor = UIColor.white
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReadArticleChildCommentTableViewCell.reuseIdentifier) as! ReadArticleChildCommentTableViewCell
                cell.comment = comment
                cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
                cell.selectionStyle = .none
                if isRecomment && parentComment?.com_id == comment.com_id {
                    cell.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: "#0E1949").withAlphaComponent(0.2)
                } else {
                    cell.contentView.backgroundColor = UIColor.white
                }
                return cell
            }
        }
    }
}

extension ReadArticleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == commentField {
            textField.resignFirstResponder()
            if isRecomment == true {
                if parentComment?.com_parent == 0 {
                    sendComment(com_parent: (parentComment?.com_id)!)
                } else {
                    sendComment(com_parent: (parentComment?.com_parent)!)
                }
                isRecomment = false
            } else {
                sendComment(com_parent: 0)
            }
            return false
        }
        return true
    }
    
    func setKeyBoardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomTableView.constant = 57 + keyboardSize.height - self.tabBarController!.tabBar.frame.height
            
            if let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.bottomTableView.constant = 57
        
        if let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
