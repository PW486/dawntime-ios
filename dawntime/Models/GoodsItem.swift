//
//  GoodsItem.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import Foundation

struct GoodsItem: Codable {
    var goods_id: Int?
    var goods_name: String?
    var goods_brand: String?
    var goods_info: String?
    var goods_price: String?
    var goods_image: String?
    var goods_images: [String]?
    var goods_like: Int?
}
