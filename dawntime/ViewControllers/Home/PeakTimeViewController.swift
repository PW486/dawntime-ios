//
//  PeakTimeViewController.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PeakTimeViewController: BaseViewController {
    var articles = [Article]()
    let backImages: [UIImage] = [#imageLiteral(resourceName: "view_peakillu1_purple"),#imageLiteral(resourceName: "view_peakillu2_green"),#imageLiteral(resourceName: "view_peakillu3_violet"),#imageLiteral(resourceName: "view_peakillu4_blue")]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func reloadDatas() {
        var newArticles = [Article]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request("http://13.125.78.152:6789/board/bestList", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        for (_, subJson):(String, JSON) in json["result"] {
                            do {
                                print(subJson)
                                let article = try decoder.decode(Article.self, from: subJson.rawData())
                                print(article)
                                newArticles.append(article)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.articles = newArticles
                    self.collectionView.reloadData()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navi_peaktime"))
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        reloadDatas()
    }
}

extension PeakTimeViewController: ArticleClickProtocol, UIGestureRecognizerDelegate {
    func articleDidSelect(_ article: Article) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadArticleViewController.reuseIdentifier) as? ReadArticleViewController else { return }
        vc.article = article
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PeakTimeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        articleDidSelect(article)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeakTimeCollectionViewCell.reuseIdentifier, for: indexPath) as! PeakTimeCollectionViewCell
        cell.backgroundImage.image = backImages[Int(arc4random_uniform(4))]
        cell.article = articles[indexPath.row]
        return cell
    }
}
