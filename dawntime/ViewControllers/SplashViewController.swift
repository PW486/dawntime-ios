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
    @IBOutlet weak var splashImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gifmanager = SwiftyGifManager(memoryLimit:20)
        let gif = UIImage(gifName: "splash")
        self.splashImage.setGifImage(gif, manager: gifmanager)
    }
}
