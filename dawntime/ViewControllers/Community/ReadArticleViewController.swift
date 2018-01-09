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
    
    @IBOutlet weak var tableView: UITableView!
    
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
            Alamofire.request("http://13.125.78.152:6789/board/delete", method: .get, parameters: ["board_id": boardID], encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
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
        actionSheetController.view.tintColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadDatas()
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
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReadArticleChildCommentTableViewCell.reuseIdentifier) as! ReadArticleChildCommentTableViewCell
                cell.comment = comment
                cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
                cell.selectionStyle = .none
                return cell
            }
        }
    }
}
