//
//  CommunityArticleTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit

class CommunityArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var article: Article? {
        didSet {
            self.categoryLabel.text = article?.board_tag
            self.titleLabel.text = article?.board_title
            self.contentLabel.text = article?.board_content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
