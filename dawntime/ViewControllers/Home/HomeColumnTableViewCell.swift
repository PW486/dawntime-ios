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

class HomeColumnTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: ColumnClickProtocol?
    var columns = [Column]()
    
    @IBOutlet weak var columnCollectionView: UICollectionView!
    
    @objc func scrollToNext() {
        if columns.count > 0 {
            let indexPath = columnCollectionView.indexPathsForVisibleItems[0]
            if columnCollectionView.isDragging == false, indexPath.row < columns.count-1  {
                let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                columnCollectionView.scrollToItem(at: nextIndexPath, at: UICollectionViewScrollPosition.right, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.columnDidSelect(columns[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeColumnCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeColumnCollectionViewCell
        cell.columnImage.kf.setImage(with: URL(string: columns[indexPath.row].column_head!))
        return cell
    }
    
    override func layoutSubviews() {
        columnCollectionView.delegate = self
        columnCollectionView.dataSource = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
    }
}
