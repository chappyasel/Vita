//
//  VCoreData.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import CoreData
import Foundation

class VCoreData {
    static let shared = VCoreData()

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Vita")
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description?.setOption(true as NSNumber,
                               forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be
                // useful during development.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.name = "viewContext"
        container.viewContext.mergePolicy =
            VMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        container.viewContext.automaticallyMergesChangesFromParent = true
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(storeRemoteChange(_:)),
//                                               name: .NSPersistentStoreRemoteChange,
//                                               object: container.persistentStoreCoordinator)
        
        return container
    }()

    var context: NSManagedObjectContext { return persistentContainer.viewContext }

    func save(author: String? = nil) {
        if context.hasChanges {
            do {
                context.transactionAuthor = author
                try context.save()
                context.transactionAuthor = nil
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may
                // be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    @objc func storeRemoteChange(_ notification: Notification) {
//        print("STORE CHANGE: \(notification.object)")
//    }

    // TODO: remove test data code
    func loadTestData() {
        do {
            let journals: [Journal] = try context.fetch(Journal.fetchRequest())
            journals.forEach { persistentContainer.viewContext.delete($0) }
        } catch {
            fatalError("Journals not removed:\n\(error)")
        }

        guard let file = Bundle.main.url(forResource: "testData.json", withExtension: nil) else {
            fatalError("Test data not loaded")
        }

        do {
            let data = try Data(contentsOf: file)
            _ = try VDecoder().decode(Journal.self, from: data)
        } catch {
            fatalError("Couldn't parse test data:\n\(error)")
        }
    }
}
