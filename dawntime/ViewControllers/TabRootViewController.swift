//
//  TabBarViewController.swift
//  dawntime
//
//  Created by PW486 on 12/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class TabRootViewController: UITabBarController, UITabBarControllerDelegate {
    let defaults = UserDefaults.standard
    
    func presentLogInPopup() -> Bool {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: LogInPopUpViewController.reuseIdentifier) as? LogInPopUpViewController else { return false }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(vc, animated: true, completion: nil)
        return false
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let _ = viewController as? HomeNaviViewController{
            ShopModel.sharedInstance.board = .Best
        } else if let _ = viewController as? ShopTabViewController{
            if defaults.bool(forKey: "logInStatus") {
                ShopModel.sharedInstance.board = .New
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: ShopNaviViewController.reuseIdentifier) as? ShopNaviViewController else { return false }
                self.present(vc, animated: true, completion: nil)
                return false
            } else {
                return self.presentLogInPopup()
            }
        } else if let _ = viewController as? CommunityNaviViewController {
            if !defaults.bool(forKey: "logInStatus") {
                return self.presentLogInPopup()
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}
