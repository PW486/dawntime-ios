//
//  ShopDelegation.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 6..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit

extension ShopViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.shopCollectionView) {
            if(shopModel.mode == .CategoryMode) {
                return shopModel.externalCategory.count
            } else {
                return shopModel.goodsItems.count
            }
        } else {
            return shopModel.externalCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.shopCollectionView){
            if(shopModel.mode == .CategoryMode){
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DetailCategoryCell
                cell.titleLabel.text = shopModel.externalCategory[indexPath.row]
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as GoodsCell
                cell.goodsItem = shopModel.goodsItems[indexPath.row]
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCell
            
            if shopModel.keyword == "NEW" || shopModel.keyword == "BEST" {
                self.sortButton.isHidden = true
            } else {
                self.sortButton.isHidden = false
            }
            if(shopModel.mode == .CategoryMode){
                cell.categoryLabel.text = shopModel.largeCategory[indexPath.row]
                return cell
            } else {
                cell.categoryLabel.text = shopModel.externalCategory[indexPath.row]
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.shopCollectionView){
            if(shopModel.mode == .CategoryMode){
                self.sortButton.isHidden = false
                shopModel.selectedIndex = indexPath
                let vc = self.storyboard?.instantiateViewController(withIdentifier: ShopViewController.reuseIdentifier) as! ShopViewController
                shopModel.mode = .GoodsMode
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: ShopDetailViewController.reuseIdentifier) as! ShopDetailViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
            shopModel.keyword = cell.categoryLabel.text!
            
            if(shopModel.mode == .CategoryMode){
                sortContainerConstant = sortContainerConstant.setMultiplier(multiplier: 0.001)
                self.sortButton.isHidden = true
            } else {
                sortContainerConstant = sortContainerConstant.setMultiplier(multiplier: 0.5)
                if shopModel.keyword == "NEW" || shopModel.keyword == "BEST" {
                    self.sortButton.isHidden = true
                } else {
                    self.sortButton.isHidden = false
                }
            }
            self.view.layoutIfNeeded()
            self.shopCollectionView.reloadData()
            self.shopModel.selectedIndex = indexPath
            self.categoryCollectionView.scrollToItem(at: shopModel.selectedIndex, at: .centeredHorizontally, animated: true)
        }
    }
}

extension ShopViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == self.shopCollectionView){
            if(shopModel.mode == .CategoryMode){
                return CGSize(width: floor((self.view.frame.width)/3 - 15), height: 30)
            } else {
                let width = floor(self.view.frame.width/2 - 15)
                return CGSize(width: width, height: width + 55)
            }
        } else {
            let categorytext = shopModel.externalCategory[indexPath.row]
            let width = categorytext.size(withAttributes: [NSAttributedStringKey.font:UIFont(name: "NotoSansCJKkr-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)]).width
            let size = CGSize(width: floor(width) , height: 20)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if(collectionView == self.shopCollectionView){
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
}
