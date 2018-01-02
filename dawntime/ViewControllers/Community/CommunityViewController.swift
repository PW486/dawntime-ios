//
//  CommunityViewController.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {
    var dropdownSelected: Bool?
    
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
    }
    
    @IBAction func menuDropdownAction(_ sender: Any) {
        if dropdownSelected! == true {
            dropdownSelected = false
            menuDropdownBtn.setTitle("˅", for: .normal)
            menuDropdown.layer.sublayers?.last?.removeFromSuperlayer()
            self.tabBarController?.tabBar.layer.sublayers?.last?.removeFromSuperlayer()
            
            menuDropdownHeight.constant = 15
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            tableView.isUserInteractionEnabled = true
            collectionView.isHidden = true
        } else {
            dropdownSelected = true
            menuDropdownBtn.setTitle("^", for: .normal)
            menuDropdownHeight.constant = 100
            menuDropdown.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)

            let border = CALayer()
            border.backgroundColor = UIColor(white: 0.5, alpha: 0.5).cgColor
            border.frame = CGRect(x: 0, y: menuDropdown.frame.size.height, width: menuDropdown.frame.size.width, height: UIScreen.main.bounds.size.height)
            menuDropdown.layer.addSublayer(border)
            
            let border2 = CALayer()
            border2.backgroundColor = UIColor(white: 0.5, alpha: 0.5).cgColor
            border2.frame = CGRect(x: 0, y: 0, width: (self.tabBarController?.tabBar.frame.size.width)!, height: (self.tabBarController?.tabBar.frame.size.height)!)
            self.tabBarController?.tabBar.layer.addSublayer(border2)
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            tableView.isUserInteractionEnabled = false
            collectionView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if dropdownSelected! == true {
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
        
        dropdownSelected = false
        menuDropdownBtn.setTitle("˅", for: .normal)
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
        
        return cell
    }
}

extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
    func articleDidSelect(_ article: Article) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadArticleViewController.reuseIdentifier) as? ReadArticleViewController else { return }
        // vc.article = article
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let article = articles[indexPath.row]
        let article = Article()
        articleDidSelect(article)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityArticleTableViewCell.reuseIdentifier, for: indexPath) as! CommunityArticleTableViewCell
        
        return cell
    }
}
