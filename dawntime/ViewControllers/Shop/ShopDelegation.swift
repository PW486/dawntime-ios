//
//  ShopDelegation.swift
//  DawnTimeApp
//
//  Created by 진호놀이터 on 2018. 1. 6..
//  Copyright © 2018년 진호놀이터. All rights reserved.
//

import UIKit


extension ShopViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //셀 개수가 아래 샵상품이라면
        if(collectionView == self.shopCollectionView){
            //근데 거기서 카테고리 상품이라면
            if(shopModel.mode == .CategoryMode){
                return shopModel.externalCategory.count
            }else{
                //진짜 상품이리면
                return shopModel.contents.count
            }
            //위에 카테고리 컬렉션뷰라면
        }else{
                return shopModel.externalCategory.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.shopCollectionView){
            if(shopModel.mode == .CategoryMode){
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DetailCategoryCell
                cell.titleLable.text = shopModel.externalCategory[indexPath.row]
                
                return cell
            }else{
                //상품 정보를 여기 셀에 넣어주세용
                return  collectionView.dequeueReusableCell(forIndexPath: indexPath) as GoodsCell
            }
        }else{
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCell
            if(shopModel.mode == .CategoryMode){
               
                cell.categoryLabel.text = shopModel.largeCategory[indexPath.row]
                
                return cell
            
            }else{
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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
                
                shopModel.mode = .GoodsMode
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
                
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
            shopModel.keyword = cell.categoryLabel.text!
            
            if(shopModel.mode == .CategoryMode){
                sortContainerConstant = sortContainerConstant.setMultiplier(multiplier: 0.001)
               
                self.sortButton.isHidden = true
                }else{
                sortContainerConstant = sortContainerConstant.setMultiplier(multiplier: 0.5)
                    self.sortButton.isHidden = false
                }
                self.view.layoutIfNeeded()
                self.shopCollectionView.reloadData()
                self.shopModel.selectedIndex = indexPath
                self.categoryCollectionView.scrollToItem(at: shopModel.selectedIndex, at: .centeredHorizontally, animated: true)
           
                }
        }
}

extension ShopViewController: UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(collectionView == self.shopCollectionView){
            if(shopModel.mode == .CategoryMode){
                return CGSize(width: floor((self.view.frame.width)/3 - 15), height: 30)
            }else{
                let wid =  floor(self.view.frame.width/2 - 15)
                return CGSize(width: wid, height: wid + 60)
            }
        }else{
            
            let categorytext = shopModel.externalCategory[indexPath.row]
            let width = categorytext.size(withAttributes: [NSAttributedStringKey.font:UIFont(name: "NotoSansCJKkr-Bold", size: 17)
                            ?? UIFont.systemFont(ofSize: 17)]).width
            let size = CGSize(width: floor(width) , height: 20)
            return size
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
        return UIEdgeInsets(top: 10, left: 10, bottom:0, right: 10)
    }
}
