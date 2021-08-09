//
//  SettingsViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit

class SettingsViewController: UIViewController {

    override func awakeFromNib() {
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 400, height: 600)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingsViewController {
    static func fromNib() -> SettingsViewController {
        // swiftlint:disable force_cast
        return Bundle.main.loadNibNamed(String(describing: SettingsViewController.self),
                                        owner: self, options: nil)?.first as! SettingsViewController
    }
}
