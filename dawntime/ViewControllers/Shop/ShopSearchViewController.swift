//
//  ShopSearchViewController.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 7..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit

class ShopSearchViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    var searchController = ShopSearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
      
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "shop_navi_search_white") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShopSearchViewController.searchKeyword))
        
        let searchTextField:UITextField = self.searchController.searchBar.subviews[0].subviews.last as! UITextField
        searchTextField.layer.cornerRadius = 20
        searchTextField.textAlignment = NSTextAlignment.left
        searchTextField.clipsToBounds = true
        
        let imageView:UIImageView = UIImageView.init(image: #imageLiteral(resourceName: "shop_navi_search_white"))
        searchTextField.leftView = nil
        searchTextField.clearButtonMode = .never
        searchTextField.placeholder = "Search"
        searchTextField.rightView = imageView
        searchTextField.rightViewMode = UITextFieldViewMode.always
    }
   
    @objc func searchKeyword(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
