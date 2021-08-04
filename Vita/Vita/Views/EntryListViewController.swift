//
//  EntryListViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit

class EntryListViewController: UIViewController {

    static func instantiateFromStoryboard() -> EntryListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(identifier: "EntryList")
                as? EntryListViewController
    }

    @IBOutlet weak var tableView: UITableView!

    var dataSource: UITableViewDiffableDataSource<Int, Entry>!
    var fetchedResultsController: NSFetchedResultsController<Entry>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        configureDataSource()
        initFetchedResultsController()
    }

    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView,
                                                   cellProvider: { (tableView, indexPath, entry) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = entry.date?.debugDescription
            return cell
        })
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
