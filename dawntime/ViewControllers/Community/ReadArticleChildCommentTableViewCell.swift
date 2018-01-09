//
//  ReadArticleChildCommentTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 09/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class ReadArticleChildCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentWriterLabel: UILabel!
    @IBOutlet weak var commentDateView: UILabel!
    @IBOutlet weak var commentContentView: UILabel!
    @IBOutlet weak var commentEraseButton: UIButton!
    
    var comment: Comment? {
        didSet {
            if let com_writer = comment?.com_writer, com_writer == 1 {
                self.commentWriterLabel.text = "익명(글쓴이)"
            } else {
                self.commentWriterLabel.text = "익명"
            }
            self.commentDateView.text = comment?.com_date
            self.commentContentView.text = comment?.com_content
            if let writer_check = comment?.writer_check, !writer_check {
                self.commentEraseButton.isHidden = true
            } else {
                self.commentEraseButton.isHidden = false
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commentView.layer.cornerRadius = 3
    }
}
