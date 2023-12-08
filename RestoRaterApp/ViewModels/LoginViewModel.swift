//
//  LoginViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI
import CoreData

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @Published var loginSuccessful = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    func loginUser(context: NSManagedObjectContext) {
        // Logic to check user credentials
        // For simplicity, this is just a placeholder logic
        let fetchRequest: NSFetchRequest<User> = User.createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let user = results.first, user.password == password { // Consider hashing the password
                loginSuccessful = true
            } else {
                alertMessage = "Invalid credentials"
                showingAlert = true
            }
        } catch {
            alertMessage = "Login Failed: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}
