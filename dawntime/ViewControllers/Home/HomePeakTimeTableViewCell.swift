//
//  HomePeakTimeTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit

protocol ArticleClickProtocol {
    func articleDidSelect(_ article: Article)
}

class HomePeakTimeTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: ArticleClickProtocol?
    var articles = [Article]()
    let backImages: [UIImage] = [#imageLiteral(resourceName: "view_peakillu1_purple"),#imageLiteral(resourceName: "view_peakillu2_green"),#imageLiteral(resourceName: "view_peakillu3_violet"),#imageLiteral(resourceName: "view_peakillu4_blue")]
    
    @IBOutlet weak var peakTimeCollectionView: UICollectionView!

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.articleDidSelect(articles[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeakTimeCollectionViewCell.reuseIdentifier, for: indexPath) as! PeakTimeCollectionViewCell
        //        cell.backgroundImage.image = backImages[Int(arc4random_uniform(4))]
        cell.backgroundImage.image = backImages[indexPath.row % 4]
        cell.article = articles[indexPath.row]
        return cell
    }
    
    override func layoutSubviews() {
        peakTimeCollectionView.delegate = self
        peakTimeCollectionView.dataSource = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
