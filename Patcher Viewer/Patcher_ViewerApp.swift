//
//  Patcher_ViewerApp.swift
//  Patcher Viewer
//
//  Created by Olivier Jobin on 31/03/2024.
//

import SwiftUI

@main
struct Patcher_ViewerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
