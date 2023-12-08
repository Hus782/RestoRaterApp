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

    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var registrationSuccessful = false

    func registerUser(context: NSManagedObjectContext) {
        let newUser = User(context: context)
        newUser.email = email
        newUser.password = password // Consider hashing the password
        newUser.name = name
        newUser.isAdmin = isAdmin

        do {
            try context.save()
            registrationSuccessful = true
        } catch {
            // Handle the error appropriately
            print("Error saving context: \(error)")
            alertMessage = "Registration Failed: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}
