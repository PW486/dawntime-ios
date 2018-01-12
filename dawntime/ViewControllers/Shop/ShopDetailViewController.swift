//
//  ReadItemViewController.swift
//  dawntime
//
//  Created by PW486 on 07/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ShopDetailViewController: BaseViewController {
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var bottomView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var goodsID: Int?
    var goodsItem: GoodsItem? {
        didSet {
            if let brand = self.goodsItem?.goods_brand {
                self.brandLabel.text = brand
            }
            if let name = self.goodsItem?.goods_name {
                self.nameLabel.text = name
            }
            if let info = self.goodsItem?.goods_info {
                self.infoLabel.text = info
            }
            if let price = self.goodsItem?.goods_price {
                self.priceLabel.text = price
            }
            if let like = self.goodsItem?.goods_like, like == 1 {
                self.likeButton.setImage(#imageLiteral(resourceName: "shop_view_heart_solid"), for: .normal)
            } else {
                self.likeButton.setImage(#imageLiteral(resourceName: "shop_view_heart_line"), for: .normal)
            }
        }
    }
    
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
                            self.likeButton.setImage(#imageLiteral(resourceName: "shop_view_heart_line"), for: .normal)
                        } else {
                            self.goodsItem?.goods_like = 1
                            self.likeButton.setImage(#imageLiteral(resourceName: "shop_view_heart_solid"), for: .normal)
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
    
    @IBAction func goToShop(_ sender: Any) {
        print("이동하기")
    }
    
    func reloadDatas() {
        var newItem = GoodsItem()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request("http://13.125.78.152:6789/shop/detail/\(goodsID!)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        do {
                            newItem = try decoder.decode(GoodsItem.self, from: json["result"].rawData())
                        }
                        catch {
                            print(error)
                        }
                    }
                    self.goodsItem = newItem
                    self.collectionView.reloadData()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "shop_navi_title"))
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: "#ED508E")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.addTopBorderWithColor(color: UIColor.lightGray, width: 0.5)
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        reloadDatas()
    }
}

extension ShopDetailViewController: UIGestureRecognizerDelegate {}

extension ShopDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let images = self.goodsItem?.goods_images {
            return images.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopDetailCollectionViewCell.reuseIdentifier, for: indexPath) as! ShopDetailCollectionViewCell
        cell.goodsImage.kf.setImage(with: URL(string: (self.goodsItem?.goods_images![indexPath.row])!))
        return cell
    }
}

extension ShopDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
}
