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
    
    var article: Article? {
        didSet {
            self.titleLabel.text = article?.board_title
            self.contentLabel.text = article?.board_content
            self.dateLabel.text = article?.board_date
            if let user_like = article?.user_like, user_like {
                self.fireImage.image = #imageLiteral(resourceName: "view_fire_red")
            }
            if let board_like = article?.board_like {
                self.fireLabel.text = "\(board_like)"
            }
            if let com_count = article?.com_count {
                self.commentLabel.text = "\(com_count)"
            }
            if let user_scrap = article?.user_scrap, user_scrap {
                self.scrapImage.image = #imageLiteral(resourceName: "view_scrap_yellow")
            }
            if let scrap_count = article?.scrap_count {
                self.scrapLabel.text = "\(scrap_count)"
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
