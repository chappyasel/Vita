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
        view.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // TODO:
    // 1. iCloud Sync toggle
    // 2. Dark mode / use device settings
    // 3. Import / export all data
    // 4. Contact us
    // 5. Share / rate
}

extension SettingsViewController {
    static func fromNib() -> SettingsViewController {
        // swiftlint:disable force_cast
        return Bundle.main.loadNibNamed(String(describing: SettingsViewController.self),
                                        owner: self, options: nil)?.first as! SettingsViewController
    }
}
