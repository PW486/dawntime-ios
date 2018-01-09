//
//  PeakTimeCollectionViewCell.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit

class PeakTimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var fireLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scrapLabel: UILabel!
    
    var article: Article? {
        didSet {
            self.titleLabel.text = article?.board_title
            self.contentLabel.text = article?.board_content
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
            if let scrap_count = article?.scrap_count {
                self.scrapLabel.text = "\(scrap_count)"
            } else {
                self.scrapLabel.text = "0"
            }
        }
    }
}
