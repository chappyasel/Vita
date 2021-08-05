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
        case name, created, lastEdit = "last_edit", lastView = "last_view", entries
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext]
                as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
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
