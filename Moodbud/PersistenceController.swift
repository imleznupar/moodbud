//
//  PersistenceController.swift
//  Moodbud
//
//  Created by Lulu on 7/2/23.
//

import Foundation
import CoreData
 
struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Diary")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Container load failed: \(error)")
            }
        }
    }
}
