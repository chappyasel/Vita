//
//  VMergePolicy.swift
//  Vita
//
//  Created by Chappy Asel on 8/11/21.
//

import Foundation
import CoreData

class VMergePolicy: NSMergePolicy {
    override func resolve(optimisticLockingConflicts list: [NSMergeConflict]) throws {
        // TODO: implement custom merge policy
        // https://speakerdeck.com/gdgcherkasy/coredata-custom-merge-policy?slide=22
        // https://github.com/objcio/core-data/blob/master/Moody/MoodyModel/MoodyMergePolicy.swift
        try super.resolve(optimisticLockingConflicts: list)
    }
}

//extension NSMergeConflict {
//    var newestUpdatedAt: Date {
//        guard let o = sourceObject as? UpdateTimestampable else { fatalError("must be UpdateTimestampable") }
//        let key = UpdateTimestampKey
//        let zeroDate = Date(timeIntervalSince1970: 0)
//        let objectDate = objectSnapshot?[key] as? Date ?? zeroDate
//        let cachedDate = cachedSnapshot?[key] as? Date ?? zeroDate
//        let persistedDate = persistedSnapshot?[key] as? Date ?? zeroDate
//        return max(o.updatedAt as Date, max(objectDate, max(cachedDate, persistedDate)))
//    }
//}

extension Sequence where Iterator.Element == NSMergeConflict {
    func conflictedObjects<T>(of cls: T.Type) -> [T] {
        let objects = map { $0.sourceObject }
        return objects.compactMap { $0 as? T }
    }

    func conflictsAndObjects<T>(of cls: T.Type) -> [(NSMergeConflict, T)] {
        return filter { $0.sourceObject is T }.map { ($0, $0.sourceObject as! T) }
    }
}
