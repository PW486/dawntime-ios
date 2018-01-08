//
//  Comment.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var com_id: Int?
    var com_parent: Int?
    var com_seq: Int?
    var com_date: String?
    var com_content: String?
    var com_writer: Int?
    var recom_check: Bool?
    var writer_check: Bool?
}
