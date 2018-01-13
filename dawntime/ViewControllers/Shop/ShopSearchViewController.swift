//
//  ShopSearchViewController.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 7..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShopSearchViewController: BaseViewController, UISearchControllerDelegate, UISearchBarDelegate {
    var searchController = ShopSearchController()
    var popKeywords = [String]()
    var recentKeywords = [String]()
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var lowPriceView: UIView!
    @IBOutlet weak var lowPriceField: UITextField!
    @IBOutlet weak var highPriceView: UIView!
    @IBOutlet weak var highPriceField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var popKeywordView: UIView!
    @IBOutlet weak var recentKeywordView: UIView!
    @IBOutlet weak var popCollectionView: UICollectionView! {
        didSet {
            self.popCollectionView.delegate = self
            self.popCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var recentCollectionView: UICollectionView! {
        didSet {
            self.recentCollectionView.delegate = self
            self.recentCollectionView.dataSource = self
        }
    }
    
    @IBAction func resetAction(_ sender: Any) {
        lowPriceField.text = ""
        highPriceField.text = ""
    }
    
    func reloadDatas() {
        if let userToken = defaults.string(forKey: "userToken") {
            self.startAnimating(type: .ballBeat, color: UIColor(white: 0.5, alpha: 1), backgroundColor: UIColor(white: 1, alpha: 0))
            Alamofire.request("http://13.125.78.152:6789/shop/keyword", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        print(json)
                        self.popKeywords = json["result"]["hot_keywords"].arrayValue.map({$0.stringValue})
                        self.recentKeywords = json["result"]["recent_keywords"].arrayValue.map({$0.stringValue})
                    }
                    self.popCollectionView.reloadData()
                    self.recentCollectionView.reloadData()
                    self.stopAnimating()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    self.stopAnimating()
                    break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
      
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "shop_navi_cancel") , style: .plain, target: self, action: #selector(searchKeyword))
        
        self.priceView.addBottomBorderWithColor(color: UIColor.hexStringToUIColor(hex: "#ED508E"), width: 0.5)
        self.popKeywordView.addBottomBorderWithColor(color: UIColor.hexStringToUIColor(hex: "#ED508E"), width: 1)
        self.recentKeywordView.addBottomBorderWithColor(color: UIColor.hexStringToUIColor(hex: "#ED508E"), width: 0.5)
        roundView(self.lowPriceView, hex: "#ED508E", radius: 12, width: 1)
        roundView(self.highPriceView, hex: "#ED508E", radius: 12, width: 1)
        roundView(self.resetButton, hex: "#ED508E", radius: 12, width: 1)
        
        reloadDatas()
    }
   
    @objc func searchKeyword(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ShopNaviViewController.reuseIdentifier) as? ShopNaviViewController else { return }
        ShopModel.sharedInstance.board = .Best
        ShopModel.sharedInstance.keyword = "BEST"
        self.present(vc, animated: false, completion: nil)
    }
}
