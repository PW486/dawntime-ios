//
//  ColumnViewController.swift
//  dawntime
//
//  Created by PW486 on 03/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class ColumnViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ColumnViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
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
