//
//  CommunityCategoryCollectionViewCell.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class CommunityCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    
    func roundFill() {
        self.layer.backgroundColor = UIColor.hexStringToUIColor(hex: "#0E1949").cgColor
        self.categoryLabel.textColor = UIColor.white
    }
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.hexStringToUIColor(hex: "#0E1949").cgColor
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
}
