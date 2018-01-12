//
//  ShopSearchPopCollectionViewCell.swift
//  dawntime
//
//  Created by PW486 on 13/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class ShopSearchPopCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var keywordLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.hexStringToUIColor(hex: "#ED508E").cgColor
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
}
