//
//  Journal+CoreDataClass.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import Foundation
import CoreData

class Journal: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case created
        case lastEdit = "last_edit"
        case lastView = "last_view"
        case entries
    }
    
    convenience init() {
        self.init(context: VCoreData.shared.context)
        self.id = UUID().uuidString
        self.name = "Untitled"
        self.created = Date()
        self.lastEdit = Date()
        self.lastView = Date()
        self.entries = NSSet()
    }

    required convenience init(from decoder: Decoder) throws {
        self.init(context: VCoreData.shared.context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.created = try container.decode(Date.self, forKey: .created)
        self.lastEdit = try container.decode(Date.self, forKey: .lastEdit)
        self.lastView = try container.decode(Date.self, forKey: .lastView)
        self.entries = try container.decode(Set<Entry>.self, forKey: .entries) as NSSet
        if let entries = self.entries as? Set<Entry> {
            entries.forEach { $0.journal = self }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(created, forKey: .created)
        try container.encode(lastEdit, forKey: .lastEdit)
        try container.encode(lastView, forKey: .lastView)
        // swiftlint:disable force_cast
        try container.encode(entries as! Set<Entry>, forKey: .entries)
    }

    static func == (lhs: Journal, rhs: Journal) -> Bool {
        return lhs.name == rhs.name
    }
}
