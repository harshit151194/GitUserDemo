//
//  Util.swift
//  GitHubUsers
//
//  Created by Darshan on 18/11/18.
//  Copyright © 2018 Harshit. All rights reserved.
//

import Foundation
import UIKit

class Util: NSObject {
    
    // MARK: - *******Alert Methods*******
    class func showNetWorkAlert() {
        
        showAlertWithMessage(NSLocalizedString("CHECK_CONNECTION_ALERT", comment: ""), title:NSLocalizedString("NO_NETWORK_ALERT", comment: ""))
    }
    
    class func showAlertWithMessage(_ message: String, title: String, handler:(()->())? = nil)
    {
        DispatchQueue.main.async {
            //** If any Alert view is alrady presented then do not show another alert
            var viewController : UIViewController!
            if let vc  = UIApplication.shared.keyWindow?.rootViewController {
                if (vc.isKind(of: UIAlertController.self)) {
                    return
                }else{
                    viewController = vc
                }
            }else{
                viewController = UIApplication.shared.keyWindow?.rootViewController!
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
                handler?()
            }))
            viewController!.present(alert, animated: true, completion: nil)
        }
    }
}
