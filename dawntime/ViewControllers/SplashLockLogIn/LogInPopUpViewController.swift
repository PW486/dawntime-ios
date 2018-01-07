//
//  LogInPopUpViewController.swift
//  dawntime
//
//  Created by PW486 on 06/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit

protocol AfterLogInProtocol {
    func afterLogin(_ model: Any)
}

class LogInPopUpViewController: BaseViewController {
    var delegate: AfterLogInProtocol?
    var model: Any?
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBAction func logInAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: LogInViewController.reuseIdentifier) as? LogInViewController else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.bool(forKey: "logInStatus") {
            self.dismiss(animated: false, completion: {
                self.delegate?.afterLogin(self.model!)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10
    }
}
