//
//  GoodsCell.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 5..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit

@IBDesignable class GoodsCell: UICollectionViewCell {
//    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var heartButon: UIButton!
    
    @IBOutlet weak var goodsPriceLabel: UILabel!
    @IBOutlet weak var goodsTitleLabel: UILabel!
    @IBOutlet weak var goodsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
   //     self.underlineView.addBottomBorderWithColor(color: UIColor.white, width:0.5)
      
       
    }

}
