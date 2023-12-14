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

    func fetchUsers(context: NSManagedObjectContext) {
        let request: NSFetchRequest<User> = User.createFetchRequest()

        do {
            users = try context.fetch(request)
        } catch {
            print("Error fetching restaurants: \(error)")
        }
    }

    func deleteUser(user: User, context: NSManagedObjectContext) {
        context.delete(user)
        
        do {
            try context.save()
        } catch {
            print("Error deleting restaurant: \(error)")
        }
    }
}
