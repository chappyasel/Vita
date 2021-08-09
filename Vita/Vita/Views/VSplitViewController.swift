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
        primaryBackgroundStyle = .sidebar
        preferredDisplayMode = .twoBesideSecondary
        minimumPrimaryColumnWidth = 250
        maximumPrimaryColumnWidth = 500
        minimumSupplementaryColumnWidth = 250
        maximumSupplementaryColumnWidth = 800
        delegate = self
        setViewController(JournalListViewController(), for: .primary)
        setViewController(EntryListViewController.fromNib(), for: .supplementary)
        setViewController(EntryViewController.fromNib(), for: .secondary)
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
