//
//  ColumnViewController.swift
//  dawntime
//
//  Created by PW486 on 03/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class ColumnViewController: UIViewController {
    var searchSelected: Bool = false
    lazy var searchBar = UISearchBar()
    
    @IBOutlet weak var tableView: UITableView!
    
    @objc func searchExit() {
        searchSelected = false
        self.navigationItem.titleView = nil
        self.navigationController?.navigationBar.topItem?.title = "커뮤니티"
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.navigationItem.rightBarButtonItems = nil
        let searchBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_search_gray"), style: .done, target: self, action: #selector(searchAction))
        self.navigationItem.rightBarButtonItem = searchBarButtonItem
        
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        tableView.isUserInteractionEnabled = true
        
        eraseDimBackground((self.navigationController?.navigationBar)!)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        searchSelected = true
        searchBar.sizeToFit()
        searchBar.placeholder = "검색"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.rightBarButtonItems = nil
        let rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_cancel_navy"), style: .done, target: self, action: #selector(searchExit))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        tableView.isUserInteractionEnabled = false
        
        dimBackground((self.navigationController?.navigationBar)!)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_search_gray"), style: .done, target: self, action: #selector(searchAction))
        self.navigationItem.rightBarButtonItem = searchBarButtonItem
    }
}

extension ColumnViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadColumnViewController.reuseIdentifier) as? ReadColumnViewController else { return }
//        vc.column = self.columns[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColumnTableViewCell.reuseIdentifier) as! ColumnTableViewCell
        cell.selectionStyle = .none
        cell.columnImage.image = #imageLiteral(resourceName: "1_colum_banner")
        return cell
    }
}

extension ColumnViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchExit()
        print("검색")
        self.tableView.reloadData()
    }
}

