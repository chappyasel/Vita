//
//  EntryViewController.swift
//  Vita
//
//  Created by Chappy Asel on 7/30/21.
//

import UIKit

class EntryViewController: UIViewController {

    var entry: Entry? {
        didSet {
            guard let entry = entry else {
                label.text = "No entry selected"
                return
            }
            label.text = entry.text
        }
    }

    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension EntryViewController {
    static func fromNib() -> EntryViewController {
        // swiftlint:disable force_cast
        return Bundle.main.loadNibNamed(String(describing: EntryViewController.self),
                                        owner: self,
                                        options: nil)?.first as! EntryViewController
    }
}
