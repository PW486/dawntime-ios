//
//  ColumnViewController.swift
//  dawntime
//
//  Created by PW486 on 03/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ColumnViewController: BaseViewController {
    var columns = [Column]()
    var dimEnabled: Bool = false
    lazy var searchBar = UISearchBarCustom()
    
    @IBOutlet weak var tableView: UITableView!
    
    @objc func searchAction() {
        self.navigationItem.titleView = searchBar
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.rightBarButtonItems = nil
        
        let rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_cancel_navy"), style: .done, target: self, action: #selector(initNaviItems))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        if !dimEnabled {
            dimEnabled = true
            dimBackground((self.navigationController?.navigationBar)!)
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            tableView.isUserInteractionEnabled = false
        }
    }
    
    @objc func initNaviItems() {
        searchBar.text = ""
        
        let label = UILabel()
        label.text = "칼럼리스트"
        label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 18)
        label.textColor = UIColor.hexStringToUIColor(hex: "#001960")
        self.navigationItem.titleView = label
        
        let searchBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_search_navy"), style: .done, target: self, action: #selector(searchAction))
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.rightBarButtonItem = searchBarButtonItem
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        if dimEnabled {
            dimEnabled = false
            eraseDimBackground((self.navigationController?.navigationBar)!)
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            tableView.isUserInteractionEnabled = true
        }
    }
    
    func reloadDatas() {
        var newColumns = [Column]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken") {
            self.startAnimating(type: .ballBeat, color: UIColor(white: 0.5, alpha: 1), backgroundColor: UIColor(white: 1, alpha: 0))
            Alamofire.request("http://13.125.78.152:6789/column/listIos", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        for (_, subJson):(String, JSON) in json["result"] {
                            do {
                                let column = try decoder.decode(Column.self, from: subJson.rawData())
                                newColumns.append(column)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.columns = newColumns
                    self.tableView.reloadData()
                    self.stopAnimating()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    self.stopAnimating()
                    break
                }
            }
        }
    }
    
    func columnSearch(_ keyword: String) {
        var newColumns = [Column]()
        let decoder = JSONDecoder()
        if let userToken = defaults.string(forKey: "userToken") {
            self.startAnimating(type: .ballBeat, color: UIColor(white: 0.5, alpha: 1), backgroundColor: UIColor(white: 1, alpha: 0))
            Alamofire.request("http://13.125.78.152:6789/column/searchIos", method: .post, parameters: ["column_title": keyword], encoding: JSONEncoding.default, headers: ["user_token": userToken]).responseJSON() {
                (res) in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        let json = JSON(value)
                        for (_, subJson):(String, JSON) in json["result"] {
                            do {
                                let column = try decoder.decode(Column.self, from: subJson.rawData())
                                newColumns.append(column)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    self.columns = newColumns
                    self.tableView.reloadData()
                    self.stopAnimating()
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                    self.stopAnimating()
                    break
                }
            }
        }
    }
    
    @objc func startReloadTableView(_ sender: UIRefreshControl) {
        if searchBar.text == "" {
            reloadDatas()
        } else {
            columnSearch(searchBar.text!)
        }
        sender.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(startReloadTableView), for: .valueChanged)
        
        initNaviItems()
        reloadDatas()
    }
}

extension ColumnViewController: UIGestureRecognizerDelegate {}

extension ColumnViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return columns.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.width * 211 / 521 + 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        initNaviItems()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadColumnViewController.reuseIdentifier) as? ReadColumnViewController else { return }
        vc.column = self.columns[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColumnTableViewCell.reuseIdentifier) as! ColumnTableViewCell
        cell.selectionStyle = .none
        cell.column = self.columns[indexPath.row]
        return cell
    }
}

extension ColumnViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if dimEnabled {
            dimEnabled = false
            eraseDimBackground((self.navigationController?.navigationBar)!)
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            tableView.isUserInteractionEnabled = true
        }
        if searchBar.text == "" {
            reloadDatas()
        } else {
            columnSearch(searchBar.text!)
        }
    }
}

