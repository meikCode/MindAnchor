//
//  MindAnchorApp.swift
//  MindAnchor
//
//  Created by Meik Eisenbraun on 14.08.2026.
//

import SwiftUI
import SwiftData

@main
struct MindAnchorApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MemoItem.self,
            CategoryTag.self,
            SubtaskItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Konnte ModelContainer nicht initialisieren: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MemoListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
