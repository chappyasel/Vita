//
//  ProfileViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit

class ProfileViewController: UIViewController {

    override func awakeFromNib() {
        modalPresentationStyle = .formSheet
        preferredContentSize = CGSize(width: 600, height: 800)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ProfileViewController {
    static func fromNib() -> ProfileViewController {
        // swiftlint:disable force_cast
        return Bundle.main.loadNibNamed(String(describing: ProfileViewController.self),
                                        owner: self, options: nil)?.first as! ProfileViewController
    }
}
