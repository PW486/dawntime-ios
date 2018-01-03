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

class CommunityViewController: UIViewController {
    var articles = [Article]()
    var dropdownSelected: Bool = false
    var searchSelected: Bool = false
    var tableViewRefreshControl = UIRefreshControl()
    lazy var searchBar = UISearchBar()
    
    @objc func searchExit() {
        searchSelected = false
        self.navigationItem.titleView = nil
        self.navigationController?.navigationBar.topItem?.title = "커뮤니티"
        self.navigationItem.rightBarButtonItems = nil
        let writeBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_write_navy"), style: .done, target: self, action: #selector(createArticleAction))
        let searchBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_search_gray"), style: .done, target: self, action: #selector(searchAction))
        self.navigationItem.rightBarButtonItems = [searchBarButtonItem, writeBarButtonItem]
        eraseDimBackground(menuDropdown)
    }
    
    @IBOutlet weak var menuDropdown: UIView!
    @IBOutlet weak var menuDropdownBtn: UIButton!
    @IBOutlet weak var menuDropdownHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func createArticleAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyBoard.instantiateViewController(withIdentifier: CreateArticleViewController.reuseIdentifier) as? CreateArticleViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        searchSelected = true
        searchBar.sizeToFit()
        searchBar.placeholder = "검색"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItems = nil
        let rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_cancel_navy"), style: .done, target: self, action: #selector(searchExit))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        if dropdownSelected == true {
            menuDropdownAction(UIButton())
        }
        dimBackground(menuDropdown)
    }
    
    func dimBackground(_ view: UIView) {
        view.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        
        let border = CALayer()
        border.backgroundColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        border.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: UIScreen.main.bounds.size.height)
        view.layer.addSublayer(border)
        
        let border2 = CALayer()
        border2.backgroundColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        border2.frame = CGRect(x: 0, y: 0, width: (self.tabBarController?.tabBar.frame.size.width)!, height: (self.tabBarController?.tabBar.frame.size.height)!)
        self.tabBarController?.tabBar.layer.addSublayer(border2)
    }
    
    func eraseDimBackground(_ view: UIView) {
        view.layer.sublayers?.last?.removeFromSuperlayer()
        self.tabBarController?.tabBar.layer.sublayers?.last?.removeFromSuperlayer()
    }
    
    @IBAction func menuDropdownAction(_ sender: UIButton) {
        if dropdownSelected == true {
            dropdownSelected = false
            menuDropdownBtn.setImage(#imageLiteral(resourceName: "navi_downarrow_navy"), for: .normal)
            eraseDimBackground(menuDropdown)
            
            menuDropdownHeight.constant = 15
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            tableView.isUserInteractionEnabled = true
            collectionView.isHidden = true
        } else {
            if searchSelected == true {
                searchExit()
            }
            dropdownSelected = true
            menuDropdownBtn.setImage(#imageLiteral(resourceName: "navi_uparrow_navy"), for: .normal)
            dimBackground(menuDropdown)
            
            self.menuDropdownHeight.constant = 100
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })

            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            tableView.isUserInteractionEnabled = false
            collectionView.isHidden = false
        }
    }
    
    func reloadArticles() {
        var newArticles = [Article]()
        let decoder = JSONDecoder()
        Alamofire.request("http://13.125.78.152:6789/board/bestList", encoding: JSONEncoding.default, headers: nil).responseJSON() {
            (res) in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let json = JSON(value)
                    for (_, subJson):(String, JSON) in json["data"] {
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
    
    @objc func startReloadTableView(_ sender: UIRefreshControl) {
        reloadArticles()
        sender.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadArticles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadArticles()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.startReloadTableView(_:)), for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if dropdownSelected == true {
            menuDropdown.layer.sublayers?.last?.removeFromSuperlayer()
            self.tabBarController?.tabBar.layer.sublayers?.last?.removeFromSuperlayer()
        }
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        
        menuDropdownHeight.constant = 15
        menuDropdown.addBottomBorderWithColor(color: UIColor.lightGray, width: 1)
        collectionView.isHidden = true
    }
}

extension CommunityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CommunityCategoryCollectionViewCell
        cell.categoryLabel.text = "\(indexPath.row)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate?.categoryDidSelect("\(indexPath.row)")
        self.dismiss(animated: false, completion: nil)
    }
}

extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
    func articleDidSelect(_ article: Article) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadArticleViewController.reuseIdentifier) as? ReadArticleViewController else { return }
//         vc.article = article
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
        
        return cell
    }
}

extension CommunityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchExit()
        print("검색")
        self.tableView.reloadData()
    }
}
