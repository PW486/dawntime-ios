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
import DropDown

class ShopViewController: BaseViewController {
    var timer: Timer?
    var shopModel = ShopModel.self.sharedInstance
    let dropDown = DropDown()
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var sortContainer: UIView!
    @IBOutlet weak var sortButton: UIButton!
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
    @IBOutlet weak var exitBottom: NSLayoutConstraint!
    
    @IBAction func dropDownAction(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func exitAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func reloadDatas() {
        let url: String?
        guard let keywordEncode = shopModel.keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        if shopModel.keyword == "NEW" || shopModel.keyword == "BEST" {
            url = "http://13.125.78.152:6789/shop/\(shopModel.board.rawValue)"
        } else {
            url = "http://13.125.78.152:6789/shop/\(shopModel.category.rawValue)/\(keywordEncode)/\(shopModel.sort.rawValue)"
        }
        var newGoodsItems = [GoodsItem]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
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
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "shop_navi_title"))
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: "#ED508E")
        if shopModel.mode == .GoodsMode {
            reloadDatas()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shopModel.keyword == "NEW" || shopModel.keyword == "BEST" || shopModel.keyword == "CATEGORY" || shopModel.keyword == "BRAND" {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropDown.textColor = UIColor.hexStringToUIColor(hex: "#ED508E")
        dropDown.textFont = UIFont(name: "NotoSansCJKkr-Regular", size: 12)!
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 7
        dropDown.shadowRadius = 7
        dropDown.shadowOffset = CGSize.zero
        dropDown.cellHeight = 35
        dropDown.anchorView = sortContainer
        
        dropDown.dataSource = shopModel.sortList
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.shopModel.sort = ShopModel.Sort(rawValue: index+1)!
            self.sortButton.setTitle(item, for: .normal)
            self.reloadDatas()
        }
        
        if shopModel.keyword != "NEW" && shopModel.keyword != "BEST" && shopModel.keyword != "CATEGORY" && shopModel.keyword != "BRAND" {
            let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "shop_navi_back"), style: .plain, target: self, action: #selector(backAction))
            self.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationItem.setLeftBarButton(backButton, animated: false)
            
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
        
        self.shopCollectionView.collectionViewLayout.invalidateLayout()
        self.shopCollectionView.register(GoodsCell.self)
        self.shopCollectionView.register(DetailCategoryCell.self)
        self.categoryCollectionView.selectItem(at: shopModel.selectedIndex, animated: true, scrollPosition: .centeredHorizontally)
        self.categoryCollectionContainer.addBottomBorderWithColor(color: UIColor.hexStringToUIColor(hex: "#ED508E"), width: 0.5)
        
        roundView(sortContainer, hex: "#ED508E", radius: 7, width: 0.5)
        self.sortButton.setTitle(shopModel.sortList[shopModel.sort.rawValue-1], for: .normal)
    }
}
