//
//  DuNawApp.swift
//  DuNaw
//
//  Created by Wilbert Devin Wijaya on 26/07/22.
//

import SwiftUI

@main
struct DuNawApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
