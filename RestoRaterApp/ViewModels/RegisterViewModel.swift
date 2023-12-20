//
//  RegisterViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//


import CoreData

final class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""  // Consider hashing the password
    @Published var name = ""
    @Published var isAdmin = false
    
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var registrationSuccessful = false
    
    private let dataManager: CoreDataManager<User>
    
    init(dataManager: CoreDataManager<User> = CoreDataManager<User>()) {
        self.dataManager = dataManager
    }
    
    func registerUser(userManager: UserManager) async {
        do {
            try await dataManager.createEntity { [weak self] newUser in
                self?.configureUser(newUser: newUser)
            }
            await MainActor.run { [weak self] in
                self?.registrationSuccessful = true
                userManager.isRegistering = false
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
}
