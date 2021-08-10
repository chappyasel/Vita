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
    private static let cellReuseID = "EntryCell"

    @IBOutlet private weak var tableView: UITableView!
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
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.register(EntryListCell.nib(),
                           forCellReuseIdentifier: EntryListViewController.cellReuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 25)
        loadFetchedResultsController()
    }

    func loadFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "journal = %@", Database.currentJournal)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchBatchSize = 20
        fetchedResultsController =
            NSFetchedResultsController(fetchRequest: fetchRequest,
                                       managedObjectContext: VCoreData.shared.context,
                                       sectionNameKeyPath: "sectionID", cacheName: "Root")
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }

    @objc func newEntryButtonPressed(_ sender: UIBarButtonItem) {
        let entry = Entry()
        entry.journal = Database.currentJournal
        present(entry: entry)
    }
    
    func present(entry: Entry?) {
        let vc = EntryViewController.fromNib()
        vc.entry = entry
        let nc = UINavigationController(rootViewController: vc)
        showDetailViewController(nc, sender: self)
    }
}

extension EntryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionInfo = fetchedResultsController.sections?[section]
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.backgroundColor = .systemBackground
        titleLabel.text = sectionInfo?.name
        return titleLabel
    }
    
    func configure(cell: EntryListCell, at indexPath: IndexPath) {
        cell.entry = fetchedResultsController.object(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: EntryListViewController.cellReuseID, for: indexPath
        ) as! EntryListCell
        cell.delegate = self
        configure(cell: cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(entry: fetchedResultsController.object(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        let deleteAction = UIAction(title: "Delete",
                                    image: UIImage(systemName: "trash"),
                                    identifier: nil,
                                    attributes: .destructive) { [weak self] _ in
            let entry = self?.fetchedResultsController.object(at: indexPath)
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
            let entry = self?.fetchedResultsController.object(at: indexPath)
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
    func controllerWillChangeContent(
            _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            guard let cell = tableView.cellForRow(at: newIndexPath!) else { break }
            configure(cell: cell as! EntryListCell, at: newIndexPath!)
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(
            _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
