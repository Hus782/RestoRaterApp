//
//  RegisterViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//


import CoreData

final class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var isAdmin = false

    func registerUser(context: NSManagedObjectContext) {
        let newUser = User(context: context)
        newUser.email = email
        newUser.password = password // Consider hashing the password
        newUser.name = name
        newUser.isAdmin = isAdmin

        do {
            try context.save()
        } catch {
            // Handle the error appropriately
            print("Error saving context: \(error)")
        }
    }
}
