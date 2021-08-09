//
//  EntryListViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit
import CoreData
import SwipeCellKit

class EntryListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var dataSource: UITableViewDiffableDataSource<Int, Entry>!
    private var fetchedResultsController: NSFetchedResultsController<Entry>!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Database.currentJournal.name
        navigationItem.largeTitleDisplayMode = .automatic
        let newEntryAction = #selector(EntryListViewController.newEntryButtonPressed(_:))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: newEntryAction)
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
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
                cell.delegate = self
                cell.entry = entry
                return cell
            }
    }

    func initFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "journal = %@", Database.currentJournal)
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

    @objc func newEntryButtonPressed(_ sender: UIBarButtonItem) {
        present(entry: Entry())
    }
    
    func present(entry: Entry?) {
        let vc = EntryViewController.fromNib()
        vc.entry = entry
        let nc = UINavigationController()
        nc.viewControllers = [vc]
        showDetailViewController(nc, sender: self)
    }
}

extension EntryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(entry: dataSource.itemIdentifier(for: indexPath))
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        let deleteAction = UIAction(title: "Delete",
                                    image: UIImage(systemName: "trash"),
                                    identifier: nil,
                                    attributes: .destructive) { [weak self] _ in
            let entry = self?.dataSource.itemIdentifier(for: indexPath)
            if let entry = entry {
                // TODO: let rest of UI know about deletion
                VCoreData.shared.context.delete(entry)
                VCoreData.shared.save()
            }
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", children: [deleteAction])
        }
    }
}

extension EntryListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        // TODO: This
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive,
                                       title: "Delete") { [weak self] action, indexPath in
            let entry = self?.dataSource.itemIdentifier(for: indexPath)
            if let entry = entry {
                // TODO: let rest of UI know about deletion
                VCoreData.shared.context.delete(entry)
                VCoreData.shared.save()
            }
        }
        deleteAction.image = UIImage(systemName: "trash")

        return [deleteAction]
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
