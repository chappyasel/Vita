//
//  EntryListCell.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit

class EntryListCell: UITableViewCell {

    var entry: Entry? {
        didSet {
            self.dateView.backgroundColor = .red
        }
    }

    @IBOutlet private weak var dateView: UIView!
    @IBOutlet private weak var weekdayLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        dateView.layer.cornerRadius = 16
    }
}

extension EntryListCell {
    static func nib() -> UINib {
        UINib(nibName: String(describing: EntryListCell.self), bundle: Bundle.main)
    }
}
