//
//  EntryListViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit

class EntryListViewController: UIViewController {

    static let storyboardID = "EntryList"
    static func instantiateFromStoryboard() -> EntryListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(identifier: storyboardID)
                as? EntryListViewController
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
