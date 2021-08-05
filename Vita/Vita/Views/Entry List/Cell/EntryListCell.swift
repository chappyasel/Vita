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

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!

    static func nib() -> UINib {
        UINib(nibName: String(describing: EntryListCell.self), bundle: Bundle.main)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        dateView.layer.cornerRadius = 16
    }
}
