//
//  MsgTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 10/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class MsgTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var message: Message? {
        didSet {
            self.titleLabel.text = (message?.board_title)! + " 에서 보낸 쪽지"
            self.contentLabel.text = message?.msg_content
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.000Z'"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy.MM.dd\nHH시mm분"
            
            let date = dateFormatterGet.date(from: (message?.msg_date)!)
            self.dateLabel.text = dateFormatterPrint.string(from: date!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
