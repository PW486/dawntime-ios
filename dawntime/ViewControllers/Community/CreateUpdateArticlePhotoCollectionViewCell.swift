//
//  CreateUpdateArticlePhotoCollectionViewCell.swift
//  dawntime
//
//  Created by PW486 on 02/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class CreateUpdateArticlePhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.hexStringToUIColor(hex: "#B3B3B3").cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
