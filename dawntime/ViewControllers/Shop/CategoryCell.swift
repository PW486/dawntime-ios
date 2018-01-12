//
//  CategoryCell.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 5..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
 
    override var isSelected: Bool {
        didSet{
            if(isSelected) {
                categoryLabel.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
            } else {
                categoryLabel.font = UIFont(name: "NotoSansCJKkr-Light", size: 15)
            }
        }
    }
}
