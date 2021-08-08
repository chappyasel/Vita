//
//  Entry+CoreDataProperties.swift
//  
//
//  Created by Chappy Asel on 8/7/21.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var id: String
    @NSManaged public var date: Date
    @NSManaged public var created: Date
    @NSManaged public var lastEdit: Date
    @NSManaged public var lastView: Date
    @NSManaged public var duration: Double
    @NSManaged public var text: String
    @NSManaged public var journal: Journal?

}
