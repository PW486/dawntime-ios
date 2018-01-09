//
//  HomeShopCollectionViewCell.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit
import Kingfisher

class HomeShopCollectionViewCell: UICollectionViewCell {
    let defaults = UserDefaults.standard
    let blindImages: [UIImage] = [#imageLiteral(resourceName: "view_blind_pink"),#imageLiteral(resourceName: "view_blind_green"),#imageLiteral(resourceName: "view_blind_purple"),#imageLiteral(resourceName: "view_blind_orange")]
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    var goodsItem: GoodsItem? {
        didSet {
            self.itemLabel.text = goodsItem?.goods_name
            if let img = goodsItem?.goods_image, defaults.bool(forKey: "logInStatus") {
                self.itemImage.kf.setImage(with: URL(string: img))
            } else {
                self.itemImage.image = blindImages[Int(arc4random_uniform(4))]
            }
        }
    }
    
    override func awakeFromNib() {
        // Circle ImageView
        itemImage.layer.borderWidth = 1
        itemImage.layer.masksToBounds = false
        itemImage.layer.borderColor = UIColor.hexStringToUIColor(hex: "#ED508E").cgColor
        itemImage.layer.cornerRadius = itemImage.frame.height/2
        itemImage.clipsToBounds = true
    }
}
