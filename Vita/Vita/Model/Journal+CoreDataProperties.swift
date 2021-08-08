//
//  Journal+CoreDataProperties.swift
//  
//
//  Created by Chappy Asel on 8/7/21.
//
//

import Foundation
import CoreData


extension Journal {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var created: Date
    @NSManaged public var lastEdit: Date
    @NSManaged public var lastView: Date
    @NSManaged public var entries: NSSet
    
}

// MARK: Generated accessors for entries
extension Journal {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Entry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Entry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}
