//
//  Article.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import Foundation

struct Article: Codable {
    var board_id: Int
    var board_title: String
    var board_content: String?
    var board_tag: String
    var board_like: Int
    var board_image: String?
    var board_date: String?
    var user_id: Int?
}
