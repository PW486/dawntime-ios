//
//  CreateArticleCategorySelectViewController.swift
//  dawntime
//
//  Created by PW486 on 02/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class CreateArticleCategorySelectViewController: UIViewController {
    var delegate: CategorySelectDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CreateArticleCategorySelectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CommunityCategoryCollectionViewCell
        cell.categoryLabel.text = "\(indexPath.row)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.categoryDidSelect("\(indexPath.row)")
        self.dismiss(animated: false, completion: nil)
    }
}
