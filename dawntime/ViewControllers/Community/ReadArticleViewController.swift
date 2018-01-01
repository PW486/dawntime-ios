//
//  ReadArticleViewController.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class ReadArticleViewController: UIViewController {
    @objc func moreMenu() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // if 글쓴이만 수정, 삭제
        let editAction: UIAlertAction = UIAlertAction(title: "글 수정", style: .default) { action -> Void in
            print("글 수정")
        }
        let delAction: UIAlertAction = UIAlertAction(title: "글 삭제", style: .default) { action -> Void in
            print("글 삭제")
        }
        
        let msgAction: UIAlertAction = UIAlertAction(title: "쪽지 보내기", style: .default) { action -> Void in
            print("쪽지보내기")
        }
        let feedbackAction: UIAlertAction = UIAlertAction(title: "글 신고", style: .destructive) { action -> Void in
            print("글 신고")
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel) { action -> Void in }
        
        actionSheetController.addAction(editAction)
        actionSheetController.addAction(delAction)
        actionSheetController.addAction(msgAction)
        actionSheetController.addAction(feedbackAction)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "1_subtitle_next"), style: .done, target: self, action: #selector(moreMenu))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

extension ReadArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.row) {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier) as! HomeTableViewCell
//            // cell.shopItems = self.shopItems
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: HomeColumnTableViewCell.reuseIdentifier) as! HomeColumnTableViewCell
//            // cell.columnURL = self.columnURL
//            cell.columnImage.image = #imageLiteral(resourceName: "1_colum_banner")
//            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReadArticleTableViewCell.reuseIdentifier) as! ReadArticleTableViewCell
            return cell
        }
    }
}
