//
//  AddEditUserViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import Foundation

final class AddEditUserViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAdmin: Bool = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    private let scenario: UserViewScenario
    private let user: User?
    private let onAddCompletion: (() -> Void)?
    private let dataManager: CoreDataManager<User>
    
    var title: String {
        switch scenario {
        case .add:
            return Lingo.addEditUserCreateTitle
        case .edit:
            return Lingo.addEditUserEditTitle
        }
    }
    
    init(scenario: UserViewScenario, dataManager: CoreDataManager<User>,  user: User? = nil, onAddCompletion: (() -> Void)? = nil) {
        self.onAddCompletion = onAddCompletion
        self.scenario = scenario
        self.user = user
        self.dataManager = dataManager
        if let user = user {
            self.name = user.name
            self.email = user.email
            self.password = user.password
            self.isAdmin = user.isAdmin
        }
    }
    
    private func configure(user: User) {
        user.name = name
        user.email = email
        user.password = password
        user.isAdmin = isAdmin
    }
    
    func addUser() async {
        do {
            try await dataManager.createEntity { [weak self] (user: User) in
                self?.configure(user: user)
            }
            await MainActor.run { [weak self] in
                self?.onAddCompletion?()
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.showingAlert = true
                self?.alertMessage = error.localizedDescription
            }
        }
    }
    
    func editUser() async {
        guard let user = user else { return }
        user.name = name
        user.email = email
        user.password = password
        user.isAdmin = isAdmin
        
        do {
            try await dataManager.saveEntity(entity: user)
            await MainActor.run { [weak self] in
                self?.onAddCompletion?()
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.showingAlert = true
                self?.alertMessage = error.localizedDescription
            }
        }
    }
}
