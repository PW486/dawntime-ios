//
//  ColumnViewController.swift
//  dawntime
//
//  Created by PW486 on 03/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class ColumnViewController: UIViewController {
    var columns = [Column]()
    var searchSelected: Bool = false
    var dimEnabled: Bool = false
    lazy var searchBar = UISearchBar()
    
    @IBOutlet weak var tableView: UITableView!
    
    @objc func searchExit() {
        searchSelected = false
        self.navigationItem.titleView = nil
        self.navigationController?.navigationBar.topItem?.title = "칼럼리스트"
        self.navigationItem.rightBarButtonItems = nil
        let searchBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_search_navy"), style: .done, target: self, action: #selector(searchAction))
        self.navigationItem.rightBarButtonItem = searchBarButtonItem
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        tableView.isUserInteractionEnabled = true
        
        if dimEnabled {
            eraseDimBackground((self.navigationController?.navigationBar)!)
            dimEnabled = false
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        searchSelected = true
        searchBar.sizeToFit()
        searchBar.placeholder = "검색"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.rightBarButtonItems = nil
        let rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_cancel_navy"), style: .done, target: self, action: #selector(searchExit))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        tableView.isUserInteractionEnabled = false
        
        if !dimEnabled {
            dimBackground((self.navigationController?.navigationBar)!)
            dimEnabled = true
        }
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
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "navi_search_navy"), style: .done, target: self, action: #selector(searchAction))
        self.navigationItem.rightBarButtonItem = searchBarButtonItem
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navi_back_navy"), style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        
        // 현재는 더미 데이터 -> 나중에 서버 통신 하기
        columns.append(Column(column_title: "1번째 칼럼 제목", column_subtitle: "1번째 칼럼 부제목", column_image: ["https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=a","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=b","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=c","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=d"], column_writer: "1번째 작성자", column_head: ["https://dummyimage.com/300x100/11ab6d/3560bd.jpg&text=a"]))
        columns.append(Column(column_title: "2번째 칼럼 제목", column_subtitle: "2번째 칼럼 부제목", column_image: ["https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=aa","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=bb","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=cc","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=dd"], column_writer: "2번째 작성자", column_head: ["https://dummyimage.com/300x100/11ab6d/3560bd.jpg&text=b"]))
        columns.append(Column(column_title: "3번째 칼럼 제목", column_subtitle: "3번째 칼럼 부제목", column_image: ["https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=aaa","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=bbb","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=ccc","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=ddd"], column_writer: "3번째 작성자", column_head: ["https://dummyimage.com/300x100/11ab6d/3560bd.jpg&text=c"]))
    }
}

extension ColumnViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return columns.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            eraseDimBackground((self.navigationController?.navigationBar)!)
            dimEnabled = false
        }
        self.tableView.reloadData()
    }
}

