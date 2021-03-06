//
//  EntryInfoViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/7/21.
//

import UIKit
import SwiftUI

class EntryInfoViewController: UIViewController {
    
    lazy var hostingView = {
        UIHostingController(rootView: EntryInfoView(entry: self.entry))
    }()
    var entry: Entry
    
    init(entry: Entry) {
        self.entry = entry
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 400, height: 600)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if targetEnvironment(macCatalyst)
        view.backgroundColor = .clear
        #else
        view.backgroundColor = .systemBackground
        navigationItem.title = "Entry Info"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        extendedLayoutIncludesOpaqueBars = true
        let doneAction = #selector(EntryInfoViewController.doneButtonPressed(_:))
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done", style: .done, target: self, action: doneAction)
        #endif
        
        addChild(hostingView)
        view.addSubview(hostingView.view)
        hostingView.view.backgroundColor = .clear
        hostingView.view.translatesAutoresizingMaskIntoConstraints = false
        hostingView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        hostingView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        hostingView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        hostingView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
