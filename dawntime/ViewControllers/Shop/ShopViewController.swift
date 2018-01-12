//
//  ShopViewController.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 6..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShopViewController: BaseViewController {
    var shopModel = ShopModel.self.sharedInstance
    
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var sortContainerConstant: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionContainer: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView! {
        didSet{
            categoryCollectionView.dataSource = self
            categoryCollectionView.delegate = self
        }
    }
    @IBOutlet weak var shopCollectionView: UICollectionView! {
        didSet{
            self.shopCollectionView.dataSource = self
            self.shopCollectionView.delegate = self
        }
    }
    
    func reloadDatas() {
        var newGoodsItems = [GoodsItem]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request("http://13.125.78.152:6789/shop/\(shopModel.board.rawValue)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        for (_, subJson):(String, JSON) in json["result"] {
                            do {
                                let goodsItem = try decoder.decode(GoodsItem.self, from: subJson.rawData())
                                newGoodsItems.append(goodsItem)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.shopModel.goodsItems = newGoodsItems
                    self.shopCollectionView.reloadData()
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
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        
        if parent == self.navigationController?.parent {
            shopModel.mode = .CategoryMode
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shopModel.mode == .CategoryMode {
            sortButton.isHidden = true
        }
        
        reloadDatas()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "shop_navi_title"))
        self.shopCollectionView.collectionViewLayout.invalidateLayout()
        self.shopCollectionView.register(GoodsCell.self)
        self.shopCollectionView.register(DetailCategoryCell.self)
        self.categoryCollectionView.selectItem(at: shopModel.selectedIndex, animated: true, scrollPosition: .centeredHorizontally)
        self.categoryCollectionContainer.addBottomBorderWithColor(color: UIColor.hexStringToUIColor(hex: "#ED508E"), width: 0.5)
    }
}
