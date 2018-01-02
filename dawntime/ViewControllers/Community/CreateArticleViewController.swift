//
//  CreateArticleViewController.swift
//  dawntime
//
//  Created by PW486 on 02/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox

class CreateArticleViewController: UIViewController {
    var imagePickerController: ImagePickerController?
    var articleImages: [UIImage] = []
    
    @IBOutlet weak var photoCollectionVeiw: UICollectionView!
    
    @IBAction func photoSelectAction(_ sender: Any) {
        present(imagePickerController!, animated: true, completion: nil)
    }
    
    @IBAction func categorySelectAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionVeiw.isHidden = true
        
        imagePickerController = ImagePickerController()
        imagePickerController?.imageLimit = 10
        imagePickerController?.delegate = self
    }
}

extension CreateArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateArticlePhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! CreateArticlePhotoCollectionViewCell
        cell.imageView.image = articleImages[indexPath.row]
        
        return cell
    }
}

extension CreateArticleViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        articleImages = images
        if articleImages.count > 0 {
            photoCollectionVeiw.isHidden = false
        } else {
            photoCollectionVeiw.isHidden = true
        }
        photoCollectionVeiw.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
