//
//  JournalListViewController.swift
//  Vita
//
//  Created by Chappy Asel on 8/9/21.
//

import UIKit
import CoreData

class JournalListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Journal>!
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
        configureCollectionView()
        configureDataSource()
        initFetchedResultsController()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout() { (sectionIndex, layoutEnvironment) in
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
            configuration.showsSeparators = false
            configuration.headerMode = .firstItemInSection
            let section = NSCollectionLayoutSection.list(using: configuration,
                                                         layoutEnvironment: layoutEnvironment)
            return section
        }
        return layout
    }

    func configureDataSource() {
        let row = UICollectionView.CellRegistration<UICollectionViewListCell, Journal> {
                cell, indexPath, journal in
            var config = UIListContentConfiguration.sidebarSubtitleCell()
            config.text = journal.name
            config.secondaryText = "\(journal.entries.count) entries"
            config.image = UIImage(systemName: "text.book.closed")
            cell.contentConfiguration = config
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
                collectionView, indexPath, journal in
            return collectionView
                .dequeueConfiguredReusableCell(using: row, for: indexPath, item: journal)
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
        try! fetchedResultsController.performFetch()
    }
    
    @objc func settingsButtonPressed(_ sender: UIBarButtonItem) {
        let vc = SettingsViewController.fromNib()
        vc.popoverPresentationController?.barButtonItem = sender
        present(vc, animated: true, completion: nil)
    }
}

extension JournalListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
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
