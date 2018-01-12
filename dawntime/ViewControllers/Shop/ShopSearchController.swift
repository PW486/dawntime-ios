//
//  ShopSearchController.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 7..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit

class ShopSearchController: UISearchController, UISearchBarDelegate {

    lazy var _searchBar: ShopSearchBar = {
        [unowned self] in
        let customSearchBar = ShopSearchBar(frame: .zero)
        customSearchBar.delegate = self
        return customSearchBar
        }()
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
