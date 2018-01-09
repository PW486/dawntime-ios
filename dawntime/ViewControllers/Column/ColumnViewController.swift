//
//  ColumnViewController.swift
//  dawntime
//
//  Created by PW486 on 03/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        initNaviItems()
        
        // 현재는 더미 데이터 -> 나중에 서버 통신 하기
        columns.append(Column(column_title: "1번째 칼럼 제목", column_subtitle: "1번째 칼럼 부제목", column_image: ["https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=a","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=b","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=c","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=d"], column_writer: "1번째 작성자", column_head: ["https://dummyimage.com/300x100/11ab6d/3560bd.jpg&text=a"]))
        columns.append(Column(column_title: "2번째 칼럼 제목", column_subtitle: "2번째 칼럼 부제목", column_image: ["https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=aa","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=bb","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=cc","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=dd"], column_writer: "2번째 작성자", column_head: ["https://dummyimage.com/300x100/11ab6d/3560bd.jpg&text=b"]))
        columns.append(Column(column_title: "3번째 칼럼 제목", column_subtitle: "3번째 칼럼 부제목", column_image: ["https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=aaa","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=bbb","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=ccc","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=ddd"], column_writer: "3번째 작성자", column_head: ["https://dummyimage.com/300x100/11ab6d/3560bd.jpg&text=c"]))
    }
}

extension ColumnViewController: UIGestureRecognizerDelegate {}

extension ColumnViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return columns.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
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
        self.tableView.reloadData()
    }
}

