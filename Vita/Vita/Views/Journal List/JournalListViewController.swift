//
//  JournalListViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/9/21.
//

import UIKit
import CoreData

class JournalListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: UITableViewDiffableDataSource<Int, Journal>!
    private var fetchedResultsController: NSFetchedResultsController<Journal>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Vita"
        navigationItem.largeTitleDisplayMode = .automatic
        let settingsAction = #selector(JournalListViewController.settingsButtonPressed(_:))
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                           style: .plain,
                                           target: self,
                                           action: settingsAction)
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        configureDataSource()
        initFetchedResultsController()
    }

    func configureDataSource() {
        dataSource =
            UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, journal in
                // swiftlint:disable force_cast
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                         for: indexPath)
                cell.textLabel?.text = journal.name
                return cell
            }
    }

    func initFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
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
    
    @objc func settingsButtonPressed(_ sender: UIBarButtonItem) {
        
    }
}

extension JournalListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        let deleteAction = UIAction(title: "Delete",
                                    image: UIImage(systemName: "trash"),
                                    identifier: nil,
                                    attributes: .destructive) { [weak self] _ in
            let journal = self?.dataSource.itemIdentifier(for: indexPath)
            if let journal = journal {
                // TODO: let rest of UI know about deletion
                VCoreData.shared.context.delete(journal)
                VCoreData.shared.save()
            }
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", children: [deleteAction])
        }
    }
}

extension JournalListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, Journal>()
        diffableDataSourceSnapshot.appendSections([0])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        dataSource?.apply(diffableDataSourceSnapshot, animatingDifferences: view.window != nil)
    }
}

extension JournalListViewController {
    static func fromNib() -> JournalListViewController {
        // swiftlint:disable force_cast
        return Bundle.main.loadNibNamed(String(describing: JournalListViewController.self),
                                        owner: self,
                                        options: nil)?.first as! JournalListViewController
    }
}
