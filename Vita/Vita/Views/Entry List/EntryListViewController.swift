//
//  EntryListViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import UIKit
import CoreData

class EntryListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var dataSource: UITableViewDiffableDataSource<Int, Entry>!
    private var fetchedResultsController: NSFetchedResultsController<Entry>!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Vita"
        navigationItem.largeTitleDisplayMode = .automatic
        let profileAction = #selector(EntryListViewController.profileButtonPressed(_:))
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"),
                                           style: .plain,
                                           target: self,
                                           action: profileAction)
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

    @objc func profileButtonPressed(_ sender: UIBarButtonItem) {
        let vc = ProfileViewController.fromNib()
        vc.popoverPresentationController?.barButtonItem = sender
        present(vc, animated: true, completion: nil)
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
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            // Write action code for the trash
            let TrashAction = UIContextualAction(style: .normal, title:  "Trash", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("Update action ...")
                success(true)
            })
            TrashAction.backgroundColor = .red

            // Write action code for the Flag
            let FlagAction = UIContextualAction(style: .normal, title:  "Flag", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("Update action ...")
                success(true)
            })
            FlagAction.backgroundColor = .orange

            // Write action code for the More
            let MoreAction = UIContextualAction(style: .normal, title:  "More", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("Update action ...")
                success(true)
            })
            MoreAction.backgroundColor = .gray


            return UISwipeActionsConfiguration(actions: [TrashAction,FlagAction,MoreAction])
        }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
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
