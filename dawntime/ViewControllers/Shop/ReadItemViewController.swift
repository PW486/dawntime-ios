//
//  ReadItemViewController.swift
//  dawntime
//
//  Created by PW486 on 07/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class ReadItemViewController: BaseViewController {
    var goodsItem: GoodsItem?

    @IBOutlet weak var itemLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 상품 상세보기 서버 통신
        itemLabel.text = goodsItem?.goods_name
    }
}
