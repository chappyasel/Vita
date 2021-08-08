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

    var weekday: String {
        let f = DateFormatter()
        f.dateFormat = "E"
        return f.string(from: date)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: date)
    }
    
    var strippedText: String {
        return text.count > 0 ? text : "Empty entry"
    }
    
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
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID().uuidString, forKey: "id")
        // TODO: adjust to GMT date
        setPrimitiveValue(Date(), forKey: "date")
        setPrimitiveValue(Date(), forKey: "created")
        setPrimitiveValue(Date(), forKey: "lastEdit")
        setPrimitiveValue(Date(), forKey: "lastView")
        setPrimitiveValue(0.0, forKey: "duration")
        setPrimitiveValue("", forKey: "text")
        setPrimitiveValue(Database.currentJournal, forKey: "journal")
    }
    
    convenience init() {
        self.init(context: VCoreData.shared.context)
    }

    required convenience init(from decoder: Decoder) throws {
        self.init(context: VCoreData.shared.context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        created = try container.decode(Date.self, forKey: .created)
        lastEdit = try container.decode(Date.self, forKey: .lastEdit)
        lastView = try container.decode(Date.self, forKey: .lastView)
        duration = try container.decode(Double.self, forKey: .duration)
        text = try container.decode(String.self, forKey: .text)
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
