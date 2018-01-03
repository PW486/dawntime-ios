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

class HomePeakTimeTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var peakTimeCollectionView: UICollectionView!
    
    var delegate: ArticleClickProtocol!
    let backImages: [UIImage] = [#imageLiteral(resourceName: "view_peakillu_blue"),#imageLiteral(resourceName: "view_peakillu_violet"),#imageLiteral(resourceName: "view_peakillu2_green"),#imageLiteral(resourceName: "view_peakillu1_purple")]
    
    override func layoutSubviews() {
        peakTimeCollectionView.delegate = self
        peakTimeCollectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let article = articles[indexPath.row]
        let article = Article()
        self.delegate.articleDidSelect(article)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeakTimeCollectionViewCell.reuseIdentifier, for: indexPath) as! PeakTimeCollectionViewCell
        cell.backgroundImage.image = backImages[Int(arc4random_uniform(4))]
    
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
