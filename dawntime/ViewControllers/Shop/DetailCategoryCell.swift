//
//  DetailCategoryCell.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 5..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit

class DetailCategoryCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleContainer.layer.masksToBounds = false
        titleContainer.layer.cornerRadius = 3
        titleContainer.clipsToBounds = true
    }
}
