//
//  UISearchBarCustom.swift
//  dawntime
//
//  Created by PW486 on 08/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
@IBDesignable

class UISearchBarCustom: UISearchBar {
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        self.sizeToFit()
        self.placeholder = "검색"
        self.setShowsCancelButton(false, animated: false)
        self.setImage(UIImage(), for: .clear, state: .normal)
        self.setSearchFieldBackgroundImage(#imageLiteral(resourceName: "navi_searchround_navy"), for: .normal)
        
        for view : UIView in (self.subviews[0]).subviews {
            if let textField = view as? UITextField {
                textField.font = UIFont(name: "NotoSansCJKkr-Regular", size: 12)
                
                let imageView = UIImageView();
                imageView.image = #imageLiteral(resourceName: "navi_search_gray");
                imageView.frame = CGRect(x: 10, y: 3, width: 20, height: 20)
                textField.addSubview(imageView)
                let leftView = UIView.init(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
                textField.leftView = leftView;
                textField.leftViewMode = UITextFieldViewMode.always
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
