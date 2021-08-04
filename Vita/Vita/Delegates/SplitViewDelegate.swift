//
//  SplitViewDelegate.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit

class SplitViewDelegate: NSObject, UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController,
                             showDetail vc: UIViewController,
                             sender: Any?) -> Bool {
        guard
            splitViewController.isCollapsed == true,
            let tabBarController = splitViewController.viewControllers.first as? UITabBarController,
            let navController = tabBarController.selectedViewController as? UINavigationController
        else { return false }

        var viewControllerToPush = vc
        if let otherNavigationController = vc as? UINavigationController {
            if let topViewController = otherNavigationController.topViewController {
                viewControllerToPush = topViewController
            }
        }
        viewControllerToPush.hidesBottomBarWhenPushed = true
        navController.pushViewController(viewControllerToPush, animated: true)

        return true
    }

}