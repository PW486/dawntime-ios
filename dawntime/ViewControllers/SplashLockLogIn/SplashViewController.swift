//
//  SplashViewController.swift
//  dawntime
//
//  Created by PW486 on 05/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import SwiftyGif

class SplashViewController: UIViewController {
    var anicount: Int = 0
    @IBOutlet weak var splashImage: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gifmanager = SwiftyGifManager(memoryLimit:20)
        let gif = UIImage(gifName: "splash")
        self.splashImage.setGifImage(gif, manager: gifmanager)
        self.splashImage.delegate = self
    }
}

extension SplashViewController: SwiftyGifDelegate {
    func gifDidStart(sender: UIImageView) {
        print("gifDidStart")
    }
    
    func gifDidLoop(sender: UIImageView) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "RootViewController") as? UITabBarController else { return }
        self.present(vc, animated: false, completion: nil)
    }
    
    func gifDidStop(sender: UIImageView) {
        print("gifDidStop")
    }
}
