//
//  SettingsViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {
    
    init() {
        super.init(style: .insetGrouped)
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 400, height: 600)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if targetEnvironment(macCatalyst)
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        #else
        navigationItem.title = "Settings"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        extendedLayoutIncludesOpaqueBars = true
        let doneAction = #selector(SettingsViewController.doneButtonPressed(_:))
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Done", style: .done, target: self, action: doneAction)
        #endif
        
        SwitchRow.defaultCellSetup = { [unowned self] cell, row in
            cell.textLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            cell.switchControl.onTintColor = view.window?.tintColor
        }
        
        ButtonRow.defaultCellSetup = { cell, row in
            cell.textLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            cell.tintColor = .label
        }
        
        ButtonRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textAlignment = .natural
        }
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "0.0"
        let build = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] ?? "0"
        form
        +++ Section(footer: "Enable an app-wide dark mode. You can also configure dark mode to " +
                            "use your device's \"Display & Brightness\" settings.")
            <<< SwitchRow("useDeviceSettings") {
                $0.title = "Use Device Settings"
                $0.value = true
            }
            .onChange { row in
                // TODO: Color
                print("Use device settings: " + String(row.value!))
            }
            <<< SwitchRow() {
                $0.title = "Dark Mode"
                $0.disabled = "$useDeviceSettings == true"
            }
            .onChange { row in
                // TODO: Color
                print("Dark: " + String(row.value!))
            }
        +++ Section(footer: "Syncs your data with other devices on your Apple iCloud account.")
            <<< SwitchRow() {
                $0.title = "iCloud Sync"
            }
            .onChange { row in
                // TODO: Sync
                print("Sync: " + String(row.value!))
            }
        +++ Section(footer: "Export and import all of your Vita data via '.vita' files. This " +
                            "record includes all of your journals and entries. Open your data " +
                            "on another device to transfer all of your Vita data!")
            <<< ButtonRow() {
                $0.title = "Import Data"
            }
            .onCellSelection { _, _ in
                // TODO: import
                print("Import data")
            }
            <<< ButtonRow() {
                $0.title = "Export All Data"
            }
            .onCellSelection { _, _ in
                // TODO: export
                print("Export data")
            }
        +++ Section(footer: "Feel free to send us an email to suggest a feature, report a bug, " +
                            "or otherwise.")
            <<< ButtonRow() {
                $0.title = "Contact us"
            }
            .onCellSelection { _, _ in
                // TODO: contact us
                print("Contact us")
            }
        +++ Section(footer: "Version: \(version) (\(build))")
            <<< ButtonRow() {
                $0.title = "Share Vita 🙌"
            }
            .onCellSelection { _, _ in
                // TODO: share Vita
                print("Share Vita")
            }
            <<< ButtonRow() {
                $0.title = "Rate Vita 🌟"
            }
            .onCellSelection { _, _ in
                // TODO: rate Vita
                print("Rate Vita")
            }
        +++ Section()
            <<< ButtonRow() {
                $0.title = "Reset Data"
                $0.cell.tintColor = .red
                $0.cell.textLabel?.textAlignment = .center
                $0.cell.textLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            }
            .onCellSelection { cell, row in
                // TODO: reset data
                print("RESET DATA!")
            }
            .cellUpdate { cell, row in
                cell.textLabel?.textAlignment = .center
            }
    }
    
    @objc func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
