//
//  CommunityViewController.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CommunityViewController: BaseViewController {
    var articles = [Article]()
    var searchTags = [String]()
    var searchKeywords = [String]()
    var dimEnabled: Bool = false
    var dropdownSelected: Bool = false
    var searchSelected: Bool = false
    lazy var searchBar = UISearchBarCustom()
    
    @IBOutlet weak var menuDropdownBtn: UIButton!
    @IBOutlet weak var menuDropdownHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func reloadDatas() {
        var newArticles = [Article]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request("http://13.125.78.152:6789/board/dateList", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        for (_, subJson):(String, JSON) in json["result"] {
                            do {
                                let article = try decoder.decode(Article.self, from: subJson.rawData())
                                newArticles.append(article)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.articles = newArticles
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }

    func reloadBySearchTags() {
        var newArticles = [Article]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request("http://13.125.78.152:6789/board/tagList", method: .post, parameters: ["tag": searchTags], encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        for (_, subJson):(String, JSON) in json["result"] {
                            do {
                                let article = try decoder.decode(Article.self, from: subJson.rawData())
                                newArticles.append(article)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.articles = newArticles
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    func reloadBySearchKeywords() {
        var newArticles = [Article]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken") {
            Alamofire.request("http://13.125.78.152:6789/board/search", method: .post, parameters: ["search_word": searchKeywords], encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        for (_, subJson):(String, JSON) in json["result"] {
                            do {
                                let article = try decoder.decode(Article.self, from: subJson.rawData())
                                newArticles.append(article)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.articles = newArticles
                    self.tableView.reloadData()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    break
                }
            }
        }
    }
    
    @objc func createArticleAction() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: CreateUpdateArticleViewController.reuseIdentifier) as? CreateUpdateArticleViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchAction() {
        searchSelected = true
        if dropdownSelected == true { menuDropdownAction(menuDropdownBtn) }
        if !dimEnabled {
            dimEnabled = true
            dimBackground(menuDropdownBtn)
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            tableView.isUserInteractionEnabled = false
        }
        
        self.navigationItem.titleView = searchBar
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.rightBarButtonItems = nil
        
        let rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_cancel_navy"), style: .done, target: self, action: #selector(initNaviItems))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @IBAction func menuDropdownAction(_ sender: UIButton) {
        if dropdownSelected {
            dropdownSelected = false
            if dimEnabled {
                dimEnabled = false
                eraseDimBackground(menuDropdownBtn)
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
                tableView.isUserInteractionEnabled = true
            }
            
            menuDropdownBtn.setImage(#imageLiteral(resourceName: "navi_downarrow_gray"), for: .normal)
            menuDropdownHeight.constant = 25
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            collectionView.isHidden = true
            if searchTags.count > 0 {
                reloadBySearchTags()
            } else {
                reloadDatas()
            }
        } else {
            dropdownSelected = true
            if searchSelected { initNaviItems() }
            if !dimEnabled {
                dimEnabled = true
                dimBackground(menuDropdownBtn)
                self.tabBarController?.tabBar.isUserInteractionEnabled = false
                tableView.isUserInteractionEnabled = false
            }
            
            menuDropdownBtn.setImage(#imageLiteral(resourceName: "navi_uparrow_gray"), for: .normal)
            self.menuDropdownHeight.constant = 100
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            collectionView.isHidden = false
        }
    }
    
    @objc func initNaviItems() {
        searchBar.text = ""
        searchSelected = false
        
        let label = UILabel()
        label.text = "커뮤니티"
        label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 18)
        label.textColor = UIColor.hexStringToUIColor(hex: "#001960")
        self.navigationItem.titleView = label
        
        let writeButtonItem = UIButton(type: UIButtonType.custom)
        writeButtonItem.setImage(#imageLiteral(resourceName: "navi_write_navy"), for: [])
        writeButtonItem.addTarget(self, action: #selector(createArticleAction), for: UIControlEvents.touchUpInside)
        writeButtonItem.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let writeBarButtonItem = UIBarButtonItem(customView: writeButtonItem)

        let searchButtonItem: UIButton = UIButton(type: UIButtonType.custom)
        searchButtonItem.setImage(#imageLiteral(resourceName: "navi_search_navy"), for: [])
        searchButtonItem.addTarget(self, action: #selector(searchAction), for: UIControlEvents.touchUpInside)
        searchButtonItem.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let searchBarButtonItem = UIBarButtonItem(customView: searchButtonItem)

        self.navigationItem.rightBarButtonItems = [searchBarButtonItem, writeBarButtonItem]
        
        if dimEnabled {
            dimEnabled = false
            eraseDimBackground(menuDropdownBtn)
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            tableView.isUserInteractionEnabled = true
        }
    }
    
    @objc func startReloadTableView(_ sender: UIRefreshControl) {
        if searchTags.count > 0 {
            reloadBySearchTags()
        } else {
            reloadDatas()
        }
        sender.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadDatas()
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if dropdownSelected == true { menuDropdownAction(menuDropdownBtn) }
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNaviItems()
        searchBar.delegate = self
        
        menuDropdownHeight.constant = 25
        menuDropdownBtn.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        collectionView.isHidden = true
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(startReloadTableView), for: .valueChanged)
        
        self.tableView.register(UINib(nibName: CommunityArticleTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CommunityArticleTableViewCell.reuseIdentifier)
        
        reloadDatas()
    }
}

extension CommunityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CommunityCategoryCollectionViewCell
        cell.categoryLabel.text = self.categories[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CommunityCategoryCollectionViewCell
        if let i = searchTags.index(of: self.categories[indexPath.item]) {
            searchTags.remove(at: i)
            cell.roundNotFill()
        } else {
            searchTags.append(self.categories[indexPath.item])
            cell.roundFill()
        }
    }
}

extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
    func articleDidSelect(_ article: Article) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadArticleViewController.reuseIdentifier) as? ReadArticleViewController else { return }
         vc.article = article
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        articleDidSelect(article)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityArticleTableViewCell.reuseIdentifier, for: indexPath) as! CommunityArticleTableViewCell
        cell.article = articles[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

extension CommunityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if dimEnabled {
            dimEnabled = false
            eraseDimBackground(menuDropdownBtn)
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            tableView.isUserInteractionEnabled = true
        }
        if let text = searchBar.text {
            searchKeywords = text.components(separatedBy: " ")
        }
        reloadBySearchKeywords()
    }
}
