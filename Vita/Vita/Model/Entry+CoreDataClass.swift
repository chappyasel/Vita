//
//  Entry+CoreDataClass.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import Foundation
import CoreData

/**
 *  Pimary key: journal + date (only one entry per date)
 */
class Entry: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case created
        case lastEdit = "last_edit"
        case lastView = "last_view"
        case duration
        case text
        case journal
    }
    
    convenience init() {
        self.init(context: VCoreData.shared.context)
        self.id = UUID().uuidString
        // TODO: adjust to GMT date
        self.date = Date()
        self.created = Date()
        self.lastEdit = Date()
        self.lastView = Date()
        self.duration = 0.0
        self.text = ""
        self.journal = Database.currentJournal
    }

    required convenience init(from decoder: Decoder) throws {
        self.init(context: VCoreData.shared.context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.date = try container.decode(Date.self, forKey: .date)
        self.created = try container.decode(Date.self, forKey: .created)
        self.lastEdit = try container.decode(Date.self, forKey: .lastEdit)
        self.lastView = try container.decode(Date.self, forKey: .lastView)
        self.duration = try container.decode(Double.self, forKey: .duration)
        self.text = try container.decode(String.self, forKey: .text)
        // 'journal' property should be assigned separately once decoded
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(created, forKey: .created)
        try container.encode(lastEdit, forKey: .lastEdit)
        try container.encode(lastView, forKey: .lastView)
        try container.encode(duration, forKey: .duration)
        try container.encode(text, forKey: .text)
        // 'journal' property will be implied upon 'entries' encoding
    }

    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.date == rhs.date && lhs.journal?.name == rhs.journal?.name
    }
}
