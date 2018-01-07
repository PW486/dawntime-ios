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
    @IBOutlet weak var column_title: UILabel!
    @IBOutlet weak var column_writer: UILabel!
    
    var column: Column? {
        didSet {
            self.column_title.text = column?.column_title
            self.column_writer.text = column?.column_writer
            if let img = column?.column_head {
                self.column_head.kf.setImage(with: URL(string: img[0]))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
