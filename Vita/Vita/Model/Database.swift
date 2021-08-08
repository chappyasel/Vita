//
//  Database.swift
//  Vita
//
//  Created by Chappy Asel on 8/6/21.
//

import Foundation

protocol VDatabase {
    static var currentJournal: Journal { get set }
    static func allJournals() -> [Journal]
    static func allEntries() -> [Entry]
}

class Database: VDatabase {
    private static let currentJournalKey = "currentJournal"
    
    static var currentJournal: Journal {
        get {
            if cachedCurrentJournal != nil { return cachedCurrentJournal! }
            guard let id = UserDefaults.standard.string(forKey: Database.currentJournalKey) else {
                // If no current journal, look for existing journals, else create new one
                let newJ = allJournals().max { $0.entries.count > $1.entries.count } ?? Journal()
                UserDefaults.standard.setValue(newJ.id, forKey: Database.currentJournalKey)
                cachedCurrentJournal = newJ
                return newJ
            }
            return allJournals().filter { $0.id == id }.first ?? Journal()
        }
        set(newEntry) {
            UserDefaults.standard.setValue(newEntry.id, forKey: Database.currentJournalKey)
            cachedCurrentJournal = newEntry
        }
    }
    static var cachedCurrentJournal: Journal?
    
    static func allJournals() -> [Journal] {
        do {
            return try VCoreData.shared.context.fetch(Journal.fetchRequest())
        } catch {
            return []
        }
    }
    
    static func allEntries() -> [Entry] {
        do {
            return try VCoreData.shared.context.fetch(Entry.fetchRequest())
        } catch {
            return []
        }
    }
}
