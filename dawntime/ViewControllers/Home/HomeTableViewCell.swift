//
//  HomeTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit
import Kingfisher

class HomeShopTableViewCell: UITableViewCell, UICollectionViewDataSource {
    var goodsItems = [GoodsItem]()
    let blindImages: [UIImage] = [#imageLiteral(resourceName: "view_blind_pink"),#imageLiteral(resourceName: "view_blind_green"),#imageLiteral(resourceName: "view_blind_purple"),#imageLiteral(resourceName: "view_blind_orange")]
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeShopCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeShopCollectionViewCell
//        cell.goodsItem = goodsItems[indexPath.row]
        
        cell.goodsItem = GoodsItem(goods_id: <#T##Int?#>, goods_name: <#T##String?#>, goods_price: <#T##Int?#>, goods_brand: <#T##String?#>, goods_image: <#T##String?#>, goods_like: <#T##Int?#>)
        
        return cell
    }
    
    override func layoutSubviews() {
        shopCollectionView.dataSource = self
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
