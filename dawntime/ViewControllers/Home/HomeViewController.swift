//
//  HomeViewController.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: BaseViewController {
    var shopCell: HomeShopTableViewCell?
    var goodsItems = [GoodsItem]()
    var columns = [Column]()
    var articles = [Article]()
    var cellHeights: [CGFloat] = [125, UIScreen.main.bounds.size.width * 72 / 360 + 42, 1120]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func shopButtonAction(_ sender: Any) {
        if defaults.bool(forKey: "logInStatus") {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: ShopNaviViewController.reuseIdentifier) as? ShopNaviViewController else { return }
            ShopModel.sharedInstance.board = .Best
            ShopModel.sharedInstance.keyword = "BEST"
            self.present(vc, animated: true, completion: nil)
        } else {
            logInPopUp()
        }
    }
    
    @IBAction func columnButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ColumnViewController.reuseIdentifier) as? ColumnViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func peakTimeButtonAction(_ sender: Any) {
        if defaults.bool(forKey: "logInStatus") {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: PeakTimeViewController.reuseIdentifier) as? PeakTimeViewController else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            logInPopUp()
        }
    }
    
    func logInPopUp(_ model: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: LogInPopUpViewController.reuseIdentifier) as? LogInPopUpViewController else { return }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.delegate = self
        vc.model = model
        self.present(vc, animated: true, completion: nil)
    }
    
    func reloadDatas() {
        var newGoodsItems = [GoodsItem]()
        var newColumns = [Column]()
        var newArticles = [Article]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request("http://13.125.78.152:6789/home", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        
                        let path = self.documentDirectory.appending("/Setting.plist")
                        var dic = NSDictionary(contentsOfFile: path) as? [String: Bool]
                        if let blind = json["user_blind"].int, blind == 1 {
                            dic!["블라인드"] = true
                        } else {
                            dic!["블라인드"] = false
                        }
                        NSDictionary(dictionary: dic!).write(toFile: path, atomically: true)
                        
                        for (_, subJson):(String, JSON) in json["main_shop"] {
                            do {
                                let goodsItem = try decoder.decode(GoodsItem.self, from: subJson.rawData())
                                newGoodsItems.append(goodsItem)
                            }
                            catch {
                                print(error)
                            }
                        }
                        
                        for (_, subJson):(String, JSON) in json["main_column"] {
                            do {
                                let column = try decoder.decode(Column.self, from: subJson.rawData())
                                newColumns.append(column)
                            }
                            catch {
                                print(error)
                            }
                        }
                        
                        for (_, subJson):(String, JSON) in json["main_peaktime"] {
                            do {
                                let article = try decoder.decode(Article.self, from: subJson.rawData())
                                newArticles.append(article)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.goodsItems = newGoodsItems
                    self.columns = newColumns
                    self.articles = newArticles
                    self.cellHeights[2] = CGFloat((self.articles.count+1)/2 * 215 + 35)
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navi_dawntime_navy"))
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.shopCell?.shopCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(initSettingAndCheckLock), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        initSettingAndCheckLock()
        
        self.tableView.separatorStyle = .none
        reloadDatas()
    }
}

extension HomeViewController: AfterLogInProtocol {
    func afterLogin(_ model: Any) {
        if model is GoodsItem {
            itemDidSelect(model as! GoodsItem)
        } else if model is Article {
            articleDidSelect(model as! Article)
        }
    }
}

extension HomeViewController: ItemClickProtocol, ColumnClickProtocol, ArticleClickProtocol {
    func itemDidSelect(_ goodsItem: GoodsItem) {
        if defaults.bool(forKey: "logInStatus") {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: ShopDetailViewController.reuseIdentifier) as? ShopDetailViewController else { return }
             vc.goodsID = goodsItem.goods_id
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            logInPopUp(goodsItem)
        }
    }
    
    func columnDidSelect(_ column: Column) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadColumnViewController.reuseIdentifier) as? ReadColumnViewController else { return }
        vc.column = column
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func articleDidSelect(_ article: Article) {
        if defaults.bool(forKey: "logInStatus") {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadArticleViewController.reuseIdentifier) as? ReadArticleViewController else { return }
             vc.article = article
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            logInPopUp(article)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.row) {
        case 0:
            shopCell = tableView.dequeueReusableCell(withIdentifier: HomeShopTableViewCell.reuseIdentifier) as? HomeShopTableViewCell
            shopCell?.delegate = self
            shopCell?.goodsItems = self.goodsItems
            shopCell?.shopCollectionView.reloadData()
            return shopCell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeColumnTableViewCell.reuseIdentifier) as! HomeColumnTableViewCell
            cell.delegate = self
            cell.columns = self.columns
            cell.columnCollectionView.reloadData()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomePeakTimeTableViewCell.reuseIdentifier) as! HomePeakTimeTableViewCell
            cell.delegate = self
            cell.articles = self.articles
            cell.peakTimeCollectionView.reloadData()
            return cell
        }
    }
}
