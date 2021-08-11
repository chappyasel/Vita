//
//  EntryListCell.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit
import SwipeCellKit

class EntryListCell: SwipeTableViewCell {

    var entry: Entry? {
        didSet {
            guard let entry = entry else { return }
            weekdayLabel.text = entry.weekday
            dayLabel.text = String(entry.day)
            entryLabel.text = entry.strippedText
        }
    }

    @IBOutlet private weak var dateView: UIView!
    @IBOutlet private weak var weekdayLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var entryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateView.backgroundColor = .secondarySystemBackground
        dateView.layer.cornerRadius = 16
    }
}

extension EntryListCell {
    static func nib() -> UINib {
        UINib(nibName: String(describing: EntryListCell.self), bundle: Bundle.main)
    }
}
