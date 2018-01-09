//
//  ReadArticleTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class ReadArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fireImage: UIImageView!
    @IBOutlet weak var fireLabel: UILabel!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scrapImage: UIImageView!
    @IBOutlet weak var scrapLabel: UILabel!
    
    @IBAction func fireTapAction(_ sender: Any) {
    }
    var article: Article? {
        didSet {
            self.titleLabel.text = article?.board_title
            self.contentLabel.text = article?.board_content
            self.dateLabel.text = article?.board_date
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
