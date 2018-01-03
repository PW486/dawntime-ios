//
//  HomeShopCollectionViewCell.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit

class HomeShopCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        // Circle Image View
        itemImage.layer.borderWidth = 1
        itemImage.layer.masksToBounds = false
        itemImage.layer.borderColor = UIColor.hexStringToUIColor(hex: "#ED508E").cgColor
        itemImage.layer.cornerRadius = itemImage.frame.height/2
        itemImage.clipsToBounds = true
    }
}
