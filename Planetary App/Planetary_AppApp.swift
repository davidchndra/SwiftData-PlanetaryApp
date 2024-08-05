//
//  Planetary_AppApp.swift
//  Planetary App
//
//  Created by David Chandra on 22/06/24.
//

import SwiftUI
import SwiftData

@main
struct Planetary_AppApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let scheme = Schema([
            Planet.self
        ])
        let modelConfiguration = ModelConfiguration(schema: scheme, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: scheme, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create model container \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
