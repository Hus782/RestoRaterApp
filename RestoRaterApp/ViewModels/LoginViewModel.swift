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
    private let dataManager: CoreDataManager<User>

    init(dataManager: CoreDataManager<User> = CoreDataManager<User>()) {
        self.dataManager = dataManager
    }
    
    func loginUser(userManager: UserManager) async {
          let predicate = NSPredicate(format: "email == %@", email)

          do {
              let results = try await dataManager.fetchEntities(predicate: predicate)
              if let user = results.first, user.password == password { // Consider hashing the password
                  await MainActor.run {
                      loginSuccessful = true
                  }
                  userManager.loginUser(user: user)
              } else {
                  await MainActor.run {
                      alertMessage = "Invalid credentials"
                      showingAlert = true
                  }
              }
          } catch {
              await MainActor.run {
                  alertMessage = "Login Failed: \(error.localizedDescription)"
                  showingAlert = true
              }
          }
      }
}
