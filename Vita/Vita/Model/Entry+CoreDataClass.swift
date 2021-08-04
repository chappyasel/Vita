//
//  Entry+CoreDataClass.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import Foundation
import CoreData

class Entry: NSManagedObject, Codable {

    enum CodingKeys: CodingKey {
        case created, date, duration, lastView, lastEdit, text, journal
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext]
                as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.created = try container.decode(Date.self, forKey: .date)
        self.date = try container.decode(Date.self, forKey: .date)
        self.duration = try container.decode(Double.self, forKey: .date)
        self.lastView = try container.decode(Date.self, forKey: .date)
        self.lastEdit = try container.decode(Date.self, forKey: .date)
        self.text = try container.decode(String.self, forKey: .date)
        self.journal = try container.decode(Journal.self, forKey: .journal)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(created, forKey: .created)
        try container.encode(date, forKey: .date)
        try container.encode(duration, forKey: .duration)
        try container.encode(lastView, forKey: .lastView)
        try container.encode(lastEdit, forKey: .lastEdit)
        try container.encode(text, forKey: .text)
        try container.encode(journal, forKey: .journal)
    }
}
