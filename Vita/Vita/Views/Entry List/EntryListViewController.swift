//
//  EntryListViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit
import CoreData

class EntryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var dataSource: UITableViewDiffableDataSource<Int, Entry>!
    var fetchedResultsController: NSFetchedResultsController<Entry>!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Vita"
        navigationItem.largeTitleDisplayMode = .automatic
        let profileAction = #selector(EntryListViewController.presentProfile(_:))
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"),
                                           style: .plain,
                                           target: self,
                                           action: profileAction)
        let newEntryAction = #selector(EntryListViewController.presentNewEntry(_:))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: newEntryAction)
        tableView.register(EntryListCell.nib(), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 25)
        configureDataSource()
        initFetchedResultsController()
    }

    func configureDataSource() {
        dataSource =
            UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, entry in
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                     for: indexPath) as! EntryListCell
            cell.entry = entry
            return cell
        }
    }

    func initFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchedResultsController =
            NSFetchedResultsController(fetchRequest: fetchRequest,
                                       managedObjectContext: VCoreData.shared.context,
                                       sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {

        }
    }

    @objc func presentProfile(_ sender: UIView) {
        navigationController?.present(ProfileViewController.fromNib(), animated: true) {

        }
    }

    @objc func presentNewEntry(_ sender: UIView) {
        print("HERE 2!")
    }
}

extension EntryListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, Entry>()
        diffableDataSourceSnapshot.appendSections([0])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        dataSource?.apply(diffableDataSourceSnapshot, animatingDifferences: view.window != nil)
    }
}

extension EntryListViewController {
    static func fromNib() -> EntryListViewController {
        // swiftlint:disable force_cast
        return Bundle.main.loadNibNamed(String(describing: EntryListViewController.self),
                                        owner: self,
                                        options: nil)?.first as! EntryListViewController
    }
}
