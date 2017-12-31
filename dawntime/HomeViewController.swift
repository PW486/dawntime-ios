//
//  HomeViewController.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let cellHeights: [CGFloat] = [96,128,400]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            return tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier) as! HomeTableViewCell
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: HomeColumnTableViewCell.reuseIdentifier) as! HomeColumnTableViewCell
        default:
            return tableView.dequeueReusableCell(withIdentifier: HomePeakTimeTableViewCell.reuseIdentifier) as! HomePeakTimeTableViewCell
        }
    }
}
