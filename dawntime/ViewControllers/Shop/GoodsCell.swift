//
//  GoodsCell.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 5..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

@IBDesignable class GoodsCell: UICollectionViewCell {
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var goodsTitleLabel: UILabel!
    @IBOutlet weak var goodsPriceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeAction(_ sender: Any) {
        if let userToken = defaults.string(forKey: "userToken"), let goodsID = goodsItem?.goods_id {
            Alamofire.request("http://13.125.78.152:6789/shop/like/\(goodsID)", method: .put, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        print(json)
                        if json["status"].bool!, let like = self.goodsItem?.goods_like, like == 1 {
                            self.goodsItem?.goods_like = 0
                            self.likeButton.setImage(#imageLiteral(resourceName: "shop_tab_heart_line"), for: .normal)
                        } else {
                            self.goodsItem?.goods_like = 1
                            self.likeButton.setImage(#imageLiteral(resourceName: "shop_tab_heart_solid"), for: .normal)
                        }
                    }
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    var goodsItem: GoodsItem? {
        didSet {
            self.goodsTitleLabel.text = goodsItem?.goods_name
            self.goodsPriceLabel.text = goodsItem?.goods_price ?? "0" + "원"
            if let img = goodsItem?.goods_image {
                self.goodsImageView.kf.setImage(with: URL(string: img))
            }
            if let like = goodsItem?.goods_like, like == 1 {
                self.likeButton.setImage(#imageLiteral(resourceName: "shop_tab_heart_solid"), for: .normal)
            } else {
                self.likeButton.setImage(#imageLiteral(resourceName: "shop_tab_heart_line"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.3
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.hexStringToUIColor(hex: "#777777").cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
