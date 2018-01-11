//
//  ShopViewController.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 6..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
     var shopModel = ShopModel.self.sharedInstance
    
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var sortContainerConstant: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionView: UICollectionView!{
        didSet{
            categoryCollectionView.dataSource = self
            categoryCollectionView.delegate = self
        }
    }
    
    @IBOutlet weak var shopCollectionView: UICollectionView!{
   
        didSet{
            self.shopCollectionView.dataSource = self
            self.shopCollectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "img1"))
        self.shopCollectionView.collectionViewLayout.invalidateLayout()
        self.shopCollectionView.register(GoodsCell.self)
        self.shopCollectionView.register(DetailCategoryCell.self)
        self.categoryCollectionView.selectItem(at: shopModel.selectedIndex, animated: true, scrollPosition: .centeredHorizontally)

    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        
        if parent == self.navigationController?.parent {
            shopModel.mode = .CategoryMode
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shopModel.mode == .CategoryMode{
            sortButton.isHidden = true
        }
    }
}


