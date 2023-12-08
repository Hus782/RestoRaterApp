//
//  RestoRaterAppApp.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

@main
struct RestoRaterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(UserManager.shared)
                .onAppear {
                    persistenceController.populateInitialDataIfNeeded()
                }
        }
    }
}
