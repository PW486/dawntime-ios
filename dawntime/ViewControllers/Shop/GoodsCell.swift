//
//  GoodsCell.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 5..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit
import Kingfisher

@IBDesignable class GoodsCell: UICollectionViewCell {
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var goodsTitleLabel: UILabel!
    @IBOutlet weak var goodsPriceLabel: UILabel!
    @IBOutlet weak var heartButon: UIButton!
    
    var goodsItem: GoodsItem? {
        didSet {
            self.goodsTitleLabel.text = goodsItem?.goods_name
            self.goodsPriceLabel.text = (goodsItem?.goods_price)! + "원"
            if let img = goodsItem?.goods_image {
                self.goodsImageView.kf.setImage(with: URL(string: img))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.3
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.hexStringToUIColor(hex: "#777777").cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
