//
//  RegisterViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//


import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""  // Consider hashing the password
    @Published var name = ""
    @Published var isAdmin = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var registrationSuccessful = false
    private let dataManager: CoreDataManager<User>
    private let userManager: UserManager
    
    init(dataManager: CoreDataManager<User> = CoreDataManager<User>(), userManager: UserManager = UserManager.shared) {
        self.dataManager = dataManager
        self.userManager = userManager
    }
    
    func registerUser() async {
        do {
            try await dataManager.createEntity { [weak self] newUser in
                self?.configureUser(newUser: newUser)
            }
            await MainActor.run { [weak self] in
                self?.registrationSuccessful = true
                self?.userManager.isRegistering = false
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.alertMessage = "\(Lingo.registrationFailed): \(error.localizedDescription)"
                self?.showingAlert = true
            }
        }
    }
    
    private func configureUser(newUser: User) {
        newUser.email = email
        newUser.password = password
        newUser.name = name
        newUser.isAdmin = isAdmin
    }
    
    func navigateToLogin() {
        userManager.isRegistering = false
    }
}
