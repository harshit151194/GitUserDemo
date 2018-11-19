//
//  LoginViewController.swift
//  GitHubUsers
//
//  Created by Darshan on 17/11/18.
//  Copyright © 2018 Harshit. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var txtFUsername: UITextField!
    @IBOutlet var txtFPassword: UITextField!
    @IBOutlet weak var btnRememberMe: UIButton!
    
    var isRemember: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateRememberMe()
        txtFUsername.text = UserDefaults.standard.value(forKey: "username") as? String
        txtFPassword.text = UserDefaults.standard.value(forKey: "password") as? String
    }
    
    private func updateRememberMe() {
        
        isRemember = UserDefaults.standard.bool(forKey: "isRemember")
        btnRememberMe.setImage(UIImage(named: !isRemember ? "checkbox_empty" : "check"), for: .normal)
    }
    
    //MARK: UIButton Actions
    @IBAction func btnRememberMe_Action(_ sender: UIButton) {
        
        UserDefaults.standard.set(!isRemember, forKey: "isRemember")
        isRemember = !isRemember
        UserDefaults.standard.synchronize()
        updateRememberMe()
    }
    
    @IBAction func btnSubmt_Action(_ sender: Any) {
        
        guard isValid() else {
            return
        }
        
        if isRemember {
            UserDefaults.standard.set(txtFUsername.text, forKey: "username")
            UserDefaults.standard.set(txtFPassword.text, forKey: "password")
        }else {
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "password")
        }
        self.navigationController?.pushViewController(HomwViewController.instance(), animated: true)
    }
    
    func isValid() -> Bool {
        
        if (txtFUsername.text?.isEmpty)! {
            Util.showAlertWithMessage("Please enter username", title: "Alert")
            return false
        }
        if (txtFPassword.text?.isEmpty)! {
            Util.showAlertWithMessage("Please enter password", title: "Alert")
            return false
        }
        
        return true
    }
}
