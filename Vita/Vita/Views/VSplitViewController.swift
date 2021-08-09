//
//  VSplitViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/5/21.
//

import UIKit

class VSplitViewController: UISplitViewController {
    
    init() {
        super.init(style: .tripleColumn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        minimumPrimaryColumnWidth = 250
        maximumPrimaryColumnWidth = 500
        minimumSupplementaryColumnWidth = 250
        maximumSupplementaryColumnWidth = 800
        delegate = self
        let primary = UINavigationController()
        let supp = UINavigationController()
        let detail = UINavigationController()
        primary.viewControllers = [JournalListViewController.fromNib()]
        supp.viewControllers = [EntryListViewController.fromNib()]
        detail.viewControllers = [EntryViewController.fromNib()]
        viewControllers = [primary, supp, detail]
    }
}

extension VSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController,
                             collapseSecondaryViewController secondaryViewController: UIViewController,
                             ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {

        if let nc = secondaryViewController as? UINavigationController {
            if let topVc = nc.topViewController {
                if let dc = topVc as? EntryViewController {
                    return dc.entry != nil
                }
            }
        }
        return true
    }

//    func splitViewController(_ splitViewController: UISplitViewController,
//                             showDetail vc: UIViewController,
//                             sender: Any?) -> Bool {
//        guard
//            splitViewController.isCollapsed == true,
//            let tabBarController = splitViewController.viewControllers.first as? UITabBarController,
//            let navController = tabBarController.selectedViewController as? UINavigationController
//        else { return false }
//
//        var viewControllerToPush = vc
//        if let otherNavigationController = vc as? UINavigationController {
//            if let topViewController = otherNavigationController.topViewController {
//                viewControllerToPush = topViewController
//            }
//        }
//        viewControllerToPush.hidesBottomBarWhenPushed = true
//        navController.pushViewController(viewControllerToPush, animated: true)
//
//        return true
//    }
}
