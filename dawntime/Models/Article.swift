//
//  Article.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import Foundation

struct Article: Codable {
    var user_id: Int
    var board_id: Int
    var board_title: String
    var board_tag: Int
    var board_like: Int
    var board_image: String?
    var board_date: String?
}
