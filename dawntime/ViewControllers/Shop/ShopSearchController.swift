//
//  ShopSearchController.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 7..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit

class ShopSearchController: UISearchController, UISearchBarDelegate {

    lazy var _searchBar: UISearchBarCustom = {
        [unowned self] in
        let customSearchBar = UISearchBarCustom()
        customSearchBar.setSearchFieldBackgroundImage(nil, for: .normal)
        customSearchBar.delegate = self
        
        for view : UIView in (customSearchBar.subviews[0]).subviews {
            if let textField = view as? UITextField {
                let imageView = UIImageView()
                imageView.image = #imageLiteral(resourceName: "navi_search_gray")
                imageView.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
                if let viewWithTag = textField.viewWithTag(100) {
                    viewWithTag.removeFromSuperview()
                }
                textField.addSubview(imageView)
                let leftView = UIView.init(frame: CGRect(x: 10, y: 0, width: 30, height: 20))
                textField.leftView = leftView;
                textField.leftViewMode = UITextFieldViewMode.always
            }
        }
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
