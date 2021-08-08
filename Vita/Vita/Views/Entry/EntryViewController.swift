//
//  EntryViewController.swift
//  Vita
//
//  Created by Chappy Asel on 7/30/21.
//

import UIKit
import Combine

class EntryViewController: UIViewController {

    var entry: Entry? {
        didSet {
            guard let entry = entry else {
                noEntryLabel.alpha = 1
                textView.alpha = 0
                navigationItem.title = ""
                navigationItem.rightBarButtonItem = nil
                return
            }
            noEntryLabel.alpha = 0
            textView.alpha = 1
            textView.text = entry.text
            navigationItem.title = StringFormatter.string(for: entry.date,
                                                          format: .shortWeekdayYear)
            let infoAction = #selector(EntryViewController.infoButtonPressed(_:))
            navigationItem.rightBarButtonItem =
                UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                               style: .plain,
                                               target: self,
                                               action: infoAction)
        }
    }

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var noEntryLabel: UILabel!

    private let textViewSubject = PassthroughSubject<UUID, Never>()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.alwaysBounceVertical = true
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = true
        textView.alpha = 0
        textViewSubject
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [unowned self] _ in
                self.saveEntry()
            }
            .store(in: &cancellables)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        saveEntry()
    }
    
    @objc func infoButtonPressed(_ sender: UIBarButtonItem) {
        let vc = EntryInfoViewController(entry: entry!)
        vc.popoverPresentationController?.barButtonItem = sender
        present(vc, animated: true, completion: nil)
    }

    func saveEntry() {
        guard let entry = entry else { return }
        entry.text = textView.text
        VCoreData.shared.save()
    }
}

extension EntryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewSubject.send(UUID())
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
