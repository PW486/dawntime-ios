//
//  HomeColumnTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit
import Kingfisher

protocol ColumnClickProtocol {
    func columnDidSelect(_ column: Column)
}

class HomeColumnTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var delegate: ColumnClickProtocol?
    var columns = [Column]()
    
    @IBOutlet weak var columnCollectionView: UICollectionView!
    
    @objc func scrollToNext() {
        if columns.count > 0 && columnCollectionView.indexPathsForVisibleItems.count != 0 {
            var indexPath = columnCollectionView.indexPathsForVisibleItems[0]
            if columnCollectionView.isDragging == false, indexPath.row < columns.count  {
                let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                columnCollectionView.scrollToItem(at: nextIndexPath, at: UICollectionViewScrollPosition.right, animated: true)
            }
            indexPath = columnCollectionView.indexPathsForVisibleItems[0]
            if columnCollectionView.isDragging == false, indexPath.row == columns.count  {
                let firstIndexPath = IndexPath(row: 0, section: indexPath.section)
                columnCollectionView.scrollToItem(at: firstIndexPath, at: UICollectionViewScrollPosition.right, animated: false)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 72 / 360)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if columns.count > 0 {
            delegate?.columnDidSelect(columns[indexPath.row % columns.count])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if columns.count > 0 {
            return (columns.count + 1)
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeColumnCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeColumnCollectionViewCell
        if columns.count > 0 {
            cell.columnImage.kf.setImage(with: URL(string: columns[indexPath.row % columns.count].column_head!))
        }
        return cell
    }
    
    override func layoutSubviews() {
        columnCollectionView.delegate = self
        columnCollectionView.dataSource = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
    }
}
