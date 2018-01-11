//
//  ShopTabBarViewController.swift
//  dawntime
//
//  Created by PW486 on 11/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class ShopTabBarViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "ShopNaviViewController") as? UINavigationController else { return }
        self.present(vc, animated: false, completion: nil)
    }
}
