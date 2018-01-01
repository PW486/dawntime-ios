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
    
    let backImages: [UIImage] = [#imageLiteral(resourceName: "1_commu_illu1"),#imageLiteral(resourceName: "1_commu_illu2"),#imageLiteral(resourceName: "1_commu_illu3"),#imageLiteral(resourceName: "1_commu_illu4")]
    
    override func layoutSubviews() {
        peakTimeCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeakTimeCollectionViewCell.reuseIdentifier, for: indexPath) as! PeakTimeCollectionViewCell
        cell.backgroundImage.image = backImages[Int(arc4random_uniform(4))]
    
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
