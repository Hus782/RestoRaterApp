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
            RegisterView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
