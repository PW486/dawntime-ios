//
//  PeakTimeViewController.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class PeakTimeViewController: UIViewController {
    let backImages: [UIImage] = [#imageLiteral(resourceName: "view_peakillu_blue"),#imageLiteral(resourceName: "view_peakillu_violet"),#imageLiteral(resourceName: "view_peakillu2_green"),#imageLiteral(resourceName: "view_peakillu1_purple")]

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.topItem?.title = "홈"
    }
}

extension PeakTimeViewController: UICollectionViewDelegate, UICollectionViewDataSource, ArticleClickProtocol {
    func articleDidSelect(_ article: Article) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadArticleViewController.reuseIdentifier) as? ReadArticleViewController else { return }
        // vc.article = article
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let article = articles[indexPath.row]
//        let article = Article()
//        articleDidSelect(article)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeakTimeCollectionViewCell.reuseIdentifier, for: indexPath) as! PeakTimeCollectionViewCell
        cell.backgroundImage.image = backImages[Int(arc4random_uniform(4))]
        
        return cell
    }
}
