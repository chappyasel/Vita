//
//  SettingsViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit

class SettingsViewController: UIViewController {

}

extension SettingsViewController {
    static func fromNib() -> SettingsViewController {
        // swiftlint:disable force_cast
        return Bundle.main.loadNibNamed(String(describing: SettingsViewController.self),
                                        owner: self, options: nil)?.first as! SettingsViewController
    }
}
