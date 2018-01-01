//
//  HomeViewController.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let cellHeights: [CGFloat] = [136,130,1120]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func peakTimeButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: PeakTimeViewController.reuseIdentifier) as? PeakTimeViewController else { return }
        //        vc.articles = self.articles
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "새벽타임"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        // 서버 통신 샵, 칼럼, 피크타임 -> struct 배열 저장 -> 콜렉션 뷰(피크 타임) 개수 만큼 cellHeight(1개 220) 수정 -> 테이블 뷰 셀에 넘기기? 또는 그냥 이동후 다시 서버 통신
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, ArticleClickProtocol {
    func articleDidSelect(_ article: Article) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadArticleViewController.reuseIdentifier) as? ReadArticleViewController else { return }
        // vc.article = article
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.row) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier) as! HomeTableViewCell
            // cell.shopItems = self.shopItems
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeColumnTableViewCell.reuseIdentifier) as! HomeColumnTableViewCell
            // cell.columnURL = self.columnURL
            cell.columnImage.image = #imageLiteral(resourceName: "1_colum_banner")
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomePeakTimeTableViewCell.reuseIdentifier) as! HomePeakTimeTableViewCell
            cell.delegate = self
            // cell.peakTimeArticles = self.peakTimeArticles
            return cell
        }
    }
}
