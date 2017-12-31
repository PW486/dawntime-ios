//
//  HomePeakTimeTableViewCell.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit

class HomePeakTimeTableViewCell: UITableViewCell, UICollectionViewDataSource {
    @IBOutlet weak var peakTimeCollectionView: UICollectionView!
    
    override func layoutSubviews() {
        peakTimeCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeakTimeCollectionViewCell.reuseIdentifier, for: indexPath) as! PeakTimeCollectionViewCell
    
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
