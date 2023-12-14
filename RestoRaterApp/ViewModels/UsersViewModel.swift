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

    func deleteUser(at offsets: IndexSet) {
        // Delete user
        users.remove(atOffsets: offsets)
    }


}
