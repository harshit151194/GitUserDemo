//
//  UIViewController+Storyboard.swift
//  Bolt
//
//  Created by Darshan Mothreja on 1/23/18.
//  Copyright © 2018 Darshan Mothreja. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func instance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = NSStringFromClass(self).components(separatedBy: ".").last!
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

    class func popToViewController (to classType: AnyClass, navigation: UINavigationController) {
        let found = navigation.viewControllers.filter({ $0.isKind(of: classType) })
        
        if found.count > 0 {
            navigation.popToViewController(found[0], animated: true)
        }else{
            navigation.popToRootViewController(animated: true)
        }
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                         options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                         options: [], metrics: nil, views: viewBindingsDict))
    }
}
