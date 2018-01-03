//
//  HomeTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell, UICollectionViewDataSource {
    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    let blindImages: [UIImage] = [#imageLiteral(resourceName: "view_blind_pink"),#imageLiteral(resourceName: "view_blind_green"),#imageLiteral(resourceName: "view_blind_purple"),#imageLiteral(resourceName: "view_blind_orange")]
    
    override func layoutSubviews() {
        shopCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeShopCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeShopCollectionViewCell
        
        // 로그인이 안되었다면 블라인드, 로그인이 되었다면 표시
        cell.itemImage.image = blindImages[Int(arc4random_uniform(4))]
        
        return cell
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
