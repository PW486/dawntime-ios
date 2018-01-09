//
//  PeakTimeViewController.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class PeakTimeViewController: BaseViewController {
    var articles = [Article]()
    let backImages: [UIImage] = [#imageLiteral(resourceName: "view_peakillu1_purple"),#imageLiteral(resourceName: "view_peakillu2_green"),#imageLiteral(resourceName: "view_peakillu3_violet"),#imageLiteral(resourceName: "view_peakillu4_blue")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navi_peaktime"))
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        articles.append(Article(board_id: 1, board_title: "1번째 글", board_tag: "일상", board_content: "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용", board_image: ["https://dummyimage.com/500x500/72ab11/bd3843.jpg&text=a"], board_like: 5, com_count: 8, scrap_count: 10, user_like: true, user_scrap: true, writer_check: true, user_id: 12, board_date: "2018-1-1"))
        articles.append(Article(board_id: 2, board_title: "2번째 글", board_tag: "일상", board_content: "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용", board_image: ["https://dummyimage.com/500x500/72ab11/bd3843.jpg&text=b"], board_like: 55, com_count: 88, scrap_count: 100, user_like: true, user_scrap: false, writer_check: true, user_id: 12, board_date: "2018-1-1"))
        articles.append(Article(board_id: 3, board_title: "3번째 글", board_tag: "일상", board_content: "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용", board_image: ["https://dummyimage.com/500x500/72ab11/bd3843.jpg&text=c"], board_like: 51, com_count: 83, scrap_count: 140, user_like: false, user_scrap: true, writer_check: false, user_id: 12, board_date: "2018-1-1"))
        articles.append(Article(board_id: 4, board_title: "4번째 글", board_tag: "일상", board_content: "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용", board_image: ["https://dummyimage.com/500x500/72ab11/bd3843.jpg&text=d"], board_like: 51, com_count: 83, scrap_count: 140, user_like: false, user_scrap: false, writer_check: true, user_id: 12, board_date: "2018-1-1"))
    }
}

extension PeakTimeViewController: ArticleClickProtocol, UIGestureRecognizerDelegate {
    func articleDidSelect(_ article: Article) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadArticleViewController.reuseIdentifier) as? ReadArticleViewController else { return }
        vc.article = article
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PeakTimeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        articleDidSelect(article)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeakTimeCollectionViewCell.reuseIdentifier, for: indexPath) as! PeakTimeCollectionViewCell
        cell.backgroundImage.image = backImages[Int(arc4random_uniform(4))]
        cell.article = articles[indexPath.row]
        return cell
    }
}
