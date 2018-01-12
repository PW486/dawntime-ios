//
//  LogInViewController.swift
//  dawntime
//
//  Created by PW486 on 06/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin
import Alamofire
import SwiftyJSON

class LogInViewController: BaseViewController, NaverThirdPartyLoginConnectionDelegate {
    func signIn(email: String, uid: String) {
        let params = ["user_email": email, "user_uid": uid] as [String : Any]
        Alamofire.request("http://13.125.78.152:6789/home/signin", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON() {
            (res) in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let data = JSON(value)
                    
                    if let userID = data["result"]["user_id"].int {
                        self.defaults.set(userID, forKey: "userID")
                    }
                    if let userEmail = data["result"]["user_email"].string {
                        self.defaults.set(userEmail, forKey: "userEmail")
                    }
                    if let userToken = data["result"]["user_token"].string {
                        self.defaults.set(userToken, forKey: "userToken")
                        print(userToken)
                    }
                    
                    self.defaults.set(true, forKey: "logInStatus")
                    self.dismiss(animated: true, completion: nil)
                }
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    func getNaverUserInfo() {
        let loginConn = NaverThirdPartyLoginConnection.getSharedInstance()
        let tokenType = loginConn?.tokenType
        let accessToken = loginConn?.accessToken
        let authorization = "\(tokenType!) \(accessToken!)"
        print(authorization)
        
        Alamofire.request("https://openapi.naver.com/v1/nid/me", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization]).responseJSON() {
            (res) in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let data = JSON(value)
                    if let gender = data["response"]["gender"].string { // -> ,gender == "F"
                        if let email = data["response"]["email"].string, let uid = data["response"]["id"].string {
                            self.signIn(email: email, uid: uid)
                        }
                    } else {
                        print("여자가 아닙니다.")
                    }
                }
                loginConn?.resetToken()
                break
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        let naverSignInViewController = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
        present(naverSignInViewController, animated: true, completion: nil)
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        getNaverUserInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        getNaverUserInfo()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("DeleteToken")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("Failed")
    }
    
    @IBAction func naverLogin(_ sender: Any) {
        let loginConn = NaverThirdPartyLoginConnection.getSharedInstance()
        loginConn?.delegate = self
        loginConn?.requestThirdPartyLogin()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
