//
//  ShopSearchDelegation.swift
//  dawntime
//
//  Created by PW486 on 13/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

extension ShopSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.popCollectionView {
            return popKeywords.count
        } else {
            return recentKeywords.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.popCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopSearchPopCollectionViewCell.reuseIdentifier, for: indexPath) as! ShopSearchPopCollectionViewCell
            cell.keywordLabel.text = popKeywords[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopSearchRecentCollectionViewCell.reuseIdentifier, for: indexPath) as! ShopSearchRecentCollectionViewCell
            cell.keywordLabel.text = recentKeywords[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension ShopSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text: String?
        if collectionView == self.popCollectionView {
            text = popKeywords[indexPath.row]
        } else {
            text = recentKeywords[indexPath.row]
        }
        let width = text?.size(withAttributes: [NSAttributedStringKey.font:UIFont(name: "NotoSansCJKkr-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)]).width
        let size = CGSize(width: floor(width!) + 50, height: 25)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
