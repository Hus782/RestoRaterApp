//
//  AddEditUserViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import Foundation
import CoreData.NSManagedObjectContext

final class AddEditUserViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAdmin: Bool = false
    private let scenario: UserViewScenario
    private let user: User?
    private let onAddCompletion: (() -> Void)?
    
    var title: String {
        switch scenario {
        case .add:
            return "Create user"
        case .edit:
            return "Edit user"
        }
    }
    
    init(scenario: UserViewScenario, user: User? = nil, onAddCompletion: (() -> Void)? = nil) {
        self.onAddCompletion = onAddCompletion
        if let user = user {
            self.name = user.name
            self.email = user.email
            self.password = user.password
            self.isAdmin = user.isAdmin
            self.scenario = .edit
            self.user = user
        } else {
            self.scenario = .add
            self.user = nil
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
    
    func editUser(context: NSManagedObjectContext) {
        guard let user = user else { return }
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
