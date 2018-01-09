//
//  CreateUpdateArticleCategoryViewController.swift
//  dawntime
//
//  Created by PW486 on 02/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class CreateUpdateArticleCategoryViewController: BaseViewController {
    var delegate: CategorySelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CreateUpdateArticleCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CommunityCategoryCollectionViewCell
        cell.categoryLabel.text = categories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.categoryDidSelect(categories[indexPath.row])
        self.dismiss(animated: false, completion: nil)
    }
}
