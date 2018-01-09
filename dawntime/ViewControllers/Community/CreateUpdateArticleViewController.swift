//
//  CreateUpdateArticleViewController.swift
//  dawntime
//
//  Created by PW486 on 02/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox
import Alamofire
import SwiftyJSON

protocol CategorySelectDelegate {
    func categoryDidSelect(_ category: String)
}

class CreateUpdateArticleViewController: BaseViewController {
    var article: Article?
    var imagePickerController: ImagePickerController?
    var imageList: [UIImage] = []
    var category: String?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var categorySelectButton: UIButton!
    @IBOutlet weak var photoSelectButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var photoCollectionVeiw: UICollectionView!
    
    @IBAction func photoSelectAction(_ sender: Any) {
        present(imagePickerController!, animated: true, completion: nil)
    }
    
    @IBAction func categorySelectAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: CreateUpdateArticleCategoryViewController.reuseIdentifier) as? CreateUpdateArticleCategoryViewController else { return }
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if category == nil {
            let alert = UIAlertController(title: "글 작성 실패", message: "머리말을 선택해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.view.tintColor = UIColor.hexStringToUIColor(hex: "#0E1949")
            self.present(alert, animated: true, completion: nil)
        } else if (titleField.text?.isEmpty)! {
            let alert = UIAlertController(title: "글 작성 실패", message: "제목을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.view.tintColor = UIColor.hexStringToUIColor(hex: "#0E1949")
            self.present(alert, animated: true, completion: nil)
        } else if contentField.textColor == UIColor.lightGray {
            let alert = UIAlertController(title: "글 작성 실패", message: "내용을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.view.tintColor = UIColor.hexStringToUIColor(hex: "#0E1949")
            self.present(alert, animated: true, completion: nil)
        } else {
            var url: String?
            if article != nil {
                url = "http://13.125.78.152:6789/board/modify"
            } else {
                url = "http://13.125.78.152:6789/board/write"
            }
            let titleData = titleField.text?.data(using: .utf8)
            let contentData = contentField.text.data(using: .utf8)
            let categoryData = category?.data(using: .utf8)
    
            if let userToken = defaults.string(forKey: "userToken") {
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    if let boardID = self.article?.board_id, let boardIdData = "\(boardID)".data(using: .utf8) {
                        multipartFormData.append(boardIdData, withName: "board_id")
                    }
                    multipartFormData.append(titleData!, withName: "board_title")
                    multipartFormData.append(contentData!, withName: "board_content")
                    multipartFormData.append(categoryData!, withName: "board_tag")
                    for image in self.imageList {
                        if let imgData = UIImagePNGRepresentation(image) {
                            multipartFormData.append(imgData, withName: "image", fileName: "image.png", mimeType: "image/png")
                        }
                    }
                }, to: url!, method: .post, headers: ["user_token": userToken]) { (encodingResult) in
                    switch encodingResult {
                    case .success(let upload,_,_):
                        upload.responseJSON(completionHandler: { (res) in
                            switch res.result {
                            case .success:
                                self.backAction()
                                break
                            case .failure(let err):
                                print(err.localizedDescription)
                                break
                            }
                        })
                        break
                    case .failure(let err):
                        print(err.localizedDescription)
                        break
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionVeiw.isHidden = true
        imagePickerController = ImagePickerController()
        imagePickerController?.imageLimit = 5
        imagePickerController?.delegate = self
        
        if article != nil {
            let label = UILabel()
            label.text = "수정하기"
            label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 18)
            label.textColor = UIColor.hexStringToUIColor(hex: "#001960")
            self.navigationItem.titleView = label
            
            titleField.text = article?.board_title
            contentField.text = article?.board_content
            categoryDidSelect((article?.board_tag)!)
            sendButton.setTitle("다시 올리기", for: .normal)
        } else {
            let label = UILabel()
            label.text = "글쓰기"
            label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 18)
            label.textColor = UIColor.hexStringToUIColor(hex: "#001960")
            self.navigationItem.titleView = label
            
            contentField.text = "해당 게시물이 악의적인 내용이나 정치적글 편향된 글을 작성 시 신고 대상이 되어 삭제되어 질 수 있습니다."
            contentField.textColor = UIColor.lightGray
        }
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        titleField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        titleField.leftViewMode = UITextFieldViewMode.always
        contentField.delegate = self
        contentField.textContainerInset = UIEdgeInsetsMake(7, 4, 7, 4)
        
        roundView(titleField, hex: "#868686", radius: 10, width: 1)
        roundView(contentField, hex: "#868686", radius: 10, width: 0.5)
        roundView(categorySelectButton, hex: "#9C9D9D", radius: 10, width: 1)
        roundView(photoSelectButton, hex: "#0E1949", radius: 10, width: 0)
        roundView(sendButton, hex: "#0E1949", radius: 10, width: 0)
    }
}

extension CreateUpdateArticleViewController: UIGestureRecognizerDelegate {}

extension CreateUpdateArticleViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "해당 게시물이 악의적인 내용이나 정치적글 편향된 글을 작성 시 신고 대상이 되어 삭제되어 질 수 있습니다."
            textView.textColor = UIColor.lightGray
        }
    }
}

extension CreateUpdateArticleViewController: CategorySelectDelegate {
    func categoryDidSelect(_ category: String) {
        categorySelectButton.setTitle(category, for: .normal)
        categorySelectButton.setTitleColor(UIColor.white, for: .normal)
        categorySelectButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#0E1949")
        self.category = category
    }
}

extension CreateUpdateArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) is CreateUpdateArticlePhotoCollectionViewCell {
            var images = [LightboxImage]()
            for img in imageList {
                images.append(LightboxImage(image: img))
            }
            let controller = LightboxController(images: images)
            controller.dynamicBackground = true
            controller.goTo(indexPath.item, animated: false)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateUpdateArticlePhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! CreateUpdateArticlePhotoCollectionViewCell
        cell.imageView.image = imageList[indexPath.row]
        return cell
    }
}

extension CreateUpdateArticleViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        lightbox.dynamicBackground = true
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imageList = images
        if imageList.count > 0 {
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
