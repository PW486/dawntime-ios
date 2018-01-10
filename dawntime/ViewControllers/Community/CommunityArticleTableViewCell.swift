//
//  CommunityArticleTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit
import Kingfisher

class CommunityArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var boardImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var fireLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scrapLabel: UILabel!
    @IBOutlet weak var fireImage: UIImageView!
    @IBOutlet weak var scrapImage: UIImageView!
    
    var article: Article? {
        didSet {
            self.categoryLabel.text = article?.board_tag
            if let img = article?.board_image {
                self.boardImageView.kf.setImage(with: URL(string: img))
            } else {
                self.boardImageView.image = nil
            }
            self.titleLabel.text = article?.board_title
            self.contentLabel.text = article?.board_content
            if let user_like = article?.user_like, user_like {
                self.fireImage.image = #imageLiteral(resourceName: "view_fire_red")
            } else {
                self.fireImage.image = #imageLiteral(resourceName: "view_unfire_navy")
            }
            if let board_like = article?.board_like {
                self.fireLabel.text = "\(board_like)"
            } else {
                self.fireLabel.text = "0"
            }
            if let com_count = article?.com_count {
                self.commentLabel.text = "\(com_count)"
            } else {
                self.commentLabel.text = "0"
            }
            if let user_scrap = article?.user_scrap, user_scrap {
                self.scrapImage.image = #imageLiteral(resourceName: "view_scrap_yellow")
            } else {
                self.scrapImage.image = #imageLiteral(resourceName: "view_unscrap_navy")
            }
            if let scrap_count = article?.scrap_count {
                self.scrapLabel.text = "\(scrap_count)"
            } else {
                self.scrapLabel.text = "0"
            }
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
