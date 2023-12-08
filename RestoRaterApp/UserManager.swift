//
//  UserManager.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//
import Foundation

final class UserManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    @Published var isRegistering: Bool = true
    
    // Singleton instance for global access
    static let shared = UserManager()

    private init() {} // Private constructor for singleton

    func loginUser(user: User) {
        currentUser = user
        isLoggedIn = true
    }

    func logoutUser() {
        currentUser = nil
        isLoggedIn = false
    }
    
}
