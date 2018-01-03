//
//  ReadColumnViewController.swift
//  dawntime
//
//  Created by PW486 on 03/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class ReadColumnViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ReadColumnViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReadColumnTableViewCell.reuseIdentifier) as! ReadColumnTableViewCell
        cell.selectionStyle = .none
        cell.cardImage.image = #imageLiteral(resourceName: "1_colum_banner")
        return cell
    }
}
