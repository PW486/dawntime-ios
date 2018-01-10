//
//  Message.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import Foundation

struct Message: Codable {
    var room_id: Int?
    var board_title: String?
    var msg_date: String?
    var msg_content: String?
    var user_send: Bool?
}
