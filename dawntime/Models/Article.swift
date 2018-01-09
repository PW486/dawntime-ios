//
//  Article.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import Foundation

struct Article: Codable {
    var board_id: Int?
    var board_title: String?
    var board_tag: String?
    var board_content: String?
    var board_image: [String]?
    var board_like: Int?
    var com_count: Int?
    var scrap_count: Int?
    var user_like: Bool?
    var user_scrap: Bool?
    var writer_check: Bool?
    var user_id: Int?
    var board_date: String?
}
