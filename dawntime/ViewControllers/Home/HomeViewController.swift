//
//  HomeViewController.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    var shopCell: HomeShopTableViewCell?
    var goodsItems = [GoodsItem]()
    var columns = [Column]()
    var articles = [Article]()
    var cellHeights: [CGFloat] = [125,125,1120]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func shopButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ShopViewController.reuseIdentifier) as? ShopViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func columnButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: ColumnViewController.reuseIdentifier) as? ColumnViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func peakTimeButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: PeakTimeViewController.reuseIdentifier) as? PeakTimeViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navi_dawntime_navy"))
        self.shopCell?.shopCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(initSettingAndCheckLock), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        initSettingAndCheckLock()
        tableView.separatorStyle = .none
        
        // 현재는 더미 데이터 -> 나중에 서버 통신 하기
        goodsItems.append(GoodsItem(goods_id: 1, goods_name: "1번째", goods_price: 10001, goods_brand: "펀팩토리1", goods_image: ["https://dummyimage.com/100x100/ab11ab/32db2c.jpg&text=a"], goods_like: 1))
        goodsItems.append(GoodsItem(goods_id: 2, goods_name: "2번째", goods_price: 10002, goods_brand: "펀팩토리2", goods_image: ["https://dummyimage.com/100x100/ab11ab/32db2c.jpg&text=b"], goods_like: 1))
        goodsItems.append(GoodsItem(goods_id: 3, goods_name: "3번째", goods_price: 10003, goods_brand: "펀팩토리3", goods_image: ["https://dummyimage.com/100x100/ab11ab/32db2c.jpg&text=c"], goods_like: 1))
        goodsItems.append(GoodsItem(goods_id: 4, goods_name: "4번째", goods_price: 10004, goods_brand: "펀팩토리4", goods_image: ["https://dummyimage.com/100x100/ab11ab/32db2c.jpg&text=d"], goods_like: 1))
        goodsItems.append(GoodsItem(goods_id: 5, goods_name: "5번째", goods_price: 10005, goods_brand: "펀팩토리5", goods_image: ["https://dummyimage.com/100x100/ab11ab/32db2c.jpg&text=e"], goods_like: 1))
        goodsItems.append(GoodsItem(goods_id: 6, goods_name: "6번째", goods_price: 10006, goods_brand: "펀팩토리6", goods_image: ["https://dummyimage.com/100x100/ab11ab/32db2c.jpg&text=f"], goods_like: 1))
        goodsItems.append(GoodsItem(goods_id: 7, goods_name: "7번째", goods_price: 10007, goods_brand: "펀팩토리7", goods_image: ["https://dummyimage.com/100x100/ab11ab/32db2c.jpg&text=g"], goods_like: 1))
        goodsItems.append(GoodsItem(goods_id: 8, goods_name: "8번째", goods_price: 10008, goods_brand: "펀팩토리8", goods_image: ["https://dummyimage.com/100x100/ab11ab/32db2c.jpg&text=h"], goods_like: 1))
        
        columns.append(Column(column_title: "1번째 칼럼 제목", column_subtitle: "1번째 칼럼 부제목", column_image: ["https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=a","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=b","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=c","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=d"], column_writer: "1번째 작성자", column_head: ["https://dummyimage.com/300x100/11ab6d/3560bd.jpg&text=a"]))
        columns.append(Column(column_title: "2번째 칼럼 제목", column_subtitle: "2번째 칼럼 부제목", column_image: ["https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=aa","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=bb","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=cc","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=dd"], column_writer: "2번째 작성자", column_head: ["https://dummyimage.com/300x100/11ab6d/3560bd.jpg&text=b"]))
        columns.append(Column(column_title: "3번째 칼럼 제목", column_subtitle: "3번째 칼럼 부제목", column_image: ["https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=aaa","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=bbb","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=ccc","https://dummyimage.com/500x500/1199ab/bd9737.jpg&text=ddd"], column_writer: "3번째 작성자", column_head: ["https://dummyimage.com/300x100/11ab6d/3560bd.jpg&text=c"]))
        
        articles.append(Article(board_id: 1, board_title: "1번째 글", board_content: "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용", board_tag: "일상", board_like: 5, com_count: 8, scrap_count: 10, board_image: ["https://dummyimage.com/500x500/72ab11/bd3843.jpg&text=a","https://dummyimage.com/500x500/72ab11/bd3843.jpg&text=aa","https://dummyimage.com/500x500/72ab11/bd3843.jpg&text=aaa","https://dummyimage.com/500x500/72ab11/bd3843.jpg&text=aaaa"], board_date: "2018-1-1", user_id: 12, user_like: true, user_scrap: true, writer_check: true))
        articles.append(Article(board_id: 2, board_title: "2번째 글", board_content: "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용", board_tag: "일상", board_like: 55, com_count: 88, scrap_count: 100, board_image: ["https://dummyimage.com/500x500/72ab11/bd3843.jpg&text=b"], board_date: "2018-1-1", user_id: 12, user_like: true, user_scrap: false, writer_check: true))
        articles.append(Article(board_id: 3, board_title: "3번째 글", board_content: "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용", board_tag: "일상", board_like: 51, com_count: 83, scrap_count: 140, board_image: ["https://dummyimage.com/500x500/72ab11/bd3843.jpg&text=c"], board_date: "2018-1-1", user_id: 12, user_like: false, user_scrap: true, writer_check: false))
        articles.append(Article(board_id: 4, board_title: "4번째 글", board_content: "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용", board_tag: "일상", board_like: 51, com_count: 83, scrap_count: 140, board_image: [], board_date: "2018-1-1", user_id: 12, user_like: false, user_scrap: false, writer_check: false))
        cellHeights[2] = CGFloat((articles.count+1)/2 * 215 + 35)
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
            guard let vc = storyBoard.instantiateViewController(withIdentifier: ReadItemViewController.reuseIdentifier) as? ReadItemViewController else { return }
             vc.goodsItem = goodsItem
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
