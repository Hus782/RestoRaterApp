//
//  UsersViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import Foundation
import CoreData

final class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var userToDelete: User?
    @Published var showingDeleteConfirmation = false
    
    func fetchUsers(context: NSManagedObjectContext) {
        let request: NSFetchRequest<User> = User.createFetchRequest()

        do {
            users = try context.fetch(request)
        } catch {
            print("Error fetching restaurants: \(error)")
            showingAlert = true
            alertMessage = error.localizedDescription
        }
    }

    func promptDelete(user: User) {
        userToDelete = user
        showingDeleteConfirmation = true
    }
    
    func deleteUser(context: NSManagedObjectContext, completion: @escaping () -> Void) {
        guard let user = userToDelete else {
            showingAlert = true
            alertMessage = "Something went wrong"
            return
        }
        
        context.delete(user)
        completion()
        do {
            try context.save()
        } catch {
            print("Error deleting restaurant: \(error)")
            showingAlert = true
            alertMessage = error.localizedDescription
        }
    }
}
