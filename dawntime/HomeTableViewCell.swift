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
    
    override func layoutSubviews() {
        shopCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeShopCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeShopCollectionViewCell
        cell.imageview.image = #imageLiteral(resourceName: "test")
        
        return cell
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
