//
//  MoodbudApp.swift
//  Moodbud
//
//  Created by Lulu on 6/9/23.
//

import SwiftUI

@main
struct MoodbudApp: App {
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                                         persistenceController.container.viewContext)
        }
    }
    
}
