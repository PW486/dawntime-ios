//
//  CollectionViewExtension.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 5..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {
    
    static var NibName: String {
        return String(describing: self)
    }
}
extension GoodsCell: NibLoadableView, ReusableView { }
extension DetailCategoryCell: NibLoadableView, ReusableView { }
extension CategoryCell: NibLoadableView, ReusableView{}



extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
   
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        
        let Nib = UINib(nibName: T.NibName, bundle: nil)
       register(Nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

