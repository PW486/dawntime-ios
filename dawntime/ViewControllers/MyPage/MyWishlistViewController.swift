//
//  MyWishlistViewController.swift
//  dawntime
//
//  Created by PW486 on 04/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyWishlistViewController: BaseViewController {
    var goodsItems = [GoodsItem]()

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    func reloadDatas() {
        var newGoodsItems = [GoodsItem]()
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request("http://13.125.78.152:6789/mypage/shopLikeList", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        print(json)
                        for (_, subJson):(String, JSON) in json["result"] {
                            print(subJson)
                            var goodsItem = GoodsItem()
                            if let like = subJson["goods_like"].int {
                                goodsItem.goods_like = like
                            }
                            if let name = subJson["goods_name"].string {
                                goodsItem.goods_name = name
                            }
                            if let price = subJson["goods_price"].int {
                                print(price)
                                goodsItem.goods_price = "\(price)"
                            }
                            if let brand = subJson["goods_brand"].string {
                                goodsItem.goods_brand = brand
                            }
                            if let img = subJson["goods_image"].string {
                                goodsItem.goods_image = img
                            }
                            if let id = subJson["goods_id"].int {
                                goodsItem.goods_id = id
                            }
                            newGoodsItems.append(goodsItem)
                        }
                    }
                    self.goodsItems = newGoodsItems
                    self.collectionView.reloadData()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        reloadDatas()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "찜 목록"
        label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 18)
        label.textColor = UIColor.hexStringToUIColor(hex: "#001960")
        self.navigationItem.titleView = label
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.collectionView.register(GoodsCell.self)
    }
}

extension MyWishlistViewController: UIGestureRecognizerDelegate {}

extension MyWishlistViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as GoodsCell
        cell.goodsItem = self.goodsItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ShopDetailViewController.reuseIdentifier) as! ShopDetailViewController
        vc.goodsID = self.goodsItems[indexPath.row].goods_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyWishlistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(self.view.frame.width/2 - 15)
        return CGSize(width: width, height: width + 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
