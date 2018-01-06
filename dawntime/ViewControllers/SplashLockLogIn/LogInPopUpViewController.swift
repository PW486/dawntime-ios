//
//  LogInPopUpViewController.swift
//  dawntime
//
//  Created by PW486 on 06/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

class LogInPopUpViewController: UIViewController {
    let defaults = UserDefaults.standard
    var logInStatus = false
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBAction func logInAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: LogInViewController.reuseIdentifier) as? LogInViewController else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logInStatus = defaults.bool(forKey: "logInStatus")
        
        if logInStatus {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10
    }
}
