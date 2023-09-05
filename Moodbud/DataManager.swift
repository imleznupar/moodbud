////
////  DataManager.swift
////  Moodbud
////
////  Created by Lulu on 7/10/23.
////
//
//import Foundation
//import CoreData
//
//class DataManager {
//    static let shared = DataManager()
//    private var entryCache: [Date: Entry] = [:]
//    
//    func getEntry(for date: Date) -> Entry? {
//        if let cachedEntry = entryCache[date] {
//            return cachedEntry
//        } else {
//            let fetchedEntry = fetchEntry(for: date)
//            entryCache[date] = fetchedEntry
//            return fetchedEntry
//        }
//    }
//    
//    private func fetchEntry(for date: Date) -> Entry? {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)
//        
//        do {
//            let results = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
//            return results.first
//        } catch {
//            print("Error fetching entry for date: \(date), \(error.localizedDescription)")
//            return nil
//        }
//    }
//}
