//
//  ReadColumnViewController.swift
//  dawntime
//
//  Created by PW486 on 03/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Kingfisher

class ReadColumnViewController: UIViewController {
    var column: Column?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ReadColumnViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (column?.column_image?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReadColumnTableViewCell.reuseIdentifier) as! ReadColumnTableViewCell
        cell.selectionStyle = .none
        cell.cardImage.kf.setImage(with: URL(string: (column?.column_image![indexPath.row])!))
        return cell
    }
}
