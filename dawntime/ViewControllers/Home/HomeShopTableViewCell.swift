//
//  HomeShopTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit
import Kingfisher

protocol ItemClickProtocol {
    func itemDidSelect(_ goodsItem: GoodsItem)
}

class HomeShopTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: ItemClickProtocol?
    var goodsItems = [GoodsItem]()
    
    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.itemDidSelect(goodsItems[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeShopCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeShopCollectionViewCell
        cell.goodsItem = goodsItems[indexPath.row]
        return cell
    }
    
    override func layoutSubviews() {
        shopCollectionView.dataSource = self
        shopCollectionView.delegate = self
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
