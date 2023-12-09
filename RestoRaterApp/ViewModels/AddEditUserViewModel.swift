//
//  AddEditUserViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import Foundation
//import SwiftUI
import CoreData.NSManagedObjectContext

final class AddEditUserViewModel: ObservableObject {
    var onAddCompletion: (() -> Void)?
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAdmin: Bool = false
    var scenario: UserViewScenario = .add
    
    var title: String {
        switch scenario {
        case .add:
            return "Create user"
        case .edit:
            return "Edit user"
        }
    }
    
    func addUser(context: NSManagedObjectContext) {
        let user = User(context: context)
        user.name = name
        user.email = email
        user.password = password
        user.isAdmin = isAdmin

        do {
            try context.save()
            onAddCompletion?() // Call the completion handler after saving
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            // Handle the error, perhaps by showing an alert
        }
    }
}
