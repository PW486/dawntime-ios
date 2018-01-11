//
//  MyPageReplyTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 04/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Kingfisher

class MyPageReplyTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var boardImageContainer: UIView!
    @IBOutlet weak var boardImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            self.categoryLabel.text = comment?.board_tag
            if let img = comment?.board_image {
                self.boardImageView.kf.setImage(with: URL(string: img))
                self.boardImageContainer.isHidden = false
            } else {
                self.boardImageView.image = nil
                self.boardImageContainer.isHidden = true
            }
            self.contentLabel.text = comment?.com_content
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryLabel.layer.backgroundColor = UIColor.hexStringToUIColor(hex: "#0E1949").cgColor
        categoryLabel.textColor = UIColor.white
        categoryLabel.layer.masksToBounds = false
        categoryLabel.layer.cornerRadius = 10
        categoryLabel.clipsToBounds = true
    }
}
