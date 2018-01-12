//
//  ColumnTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 03/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Kingfisher

class ColumnTableViewCell: UITableViewCell {
    @IBOutlet weak var column_head: UIImageView!
    
    var column: Column? {
        didSet {
            if let img = column?.column_head {
                self.column_head.kf.setImage(with: URL(string: img))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
