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
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID().uuidString, forKey: "id")
        setPrimitiveValue("Unititled", forKey: "name")
        setPrimitiveValue(Date(), forKey: "created")
        setPrimitiveValue(Date(), forKey: "lastEdit")
        setPrimitiveValue(Date(), forKey: "lastView")
        setPrimitiveValue(NSSet(), forKey: "entries")
    }
    
    convenience init() {
        self.init(context: VCoreData.shared.context)
    }

    required convenience init(from decoder: Decoder) throws {
        self.init(context: VCoreData.shared.context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        created = try container.decode(Date.self, forKey: .created)
        lastEdit = try container.decode(Date.self, forKey: .lastEdit)
        lastView = try container.decode(Date.self, forKey: .lastView)
        entries = try container.decode(Set<Entry>.self, forKey: .entries) as NSSet
        if let entries = entries as? Set<Entry> {
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
