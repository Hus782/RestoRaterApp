//
//  MockUserManager.swift
//  RestoRaterAppTests
//
//  Created by user249550 on 12/20/23.
//

import Foundation
@testable import RestoRaterApp

class MockUserManager: UserManagerProtocol {
    var isRegistering = false
    var isLoggedIn = false
    var loggedInUser: UserData?
    var isCurrent = false
    
    func isCurrentUser(user: User) -> Bool {
        return isCurrent
    }
    
    func logoutUser() {
        loggedInUser = nil
        isLoggedIn = false
    }
    
    func setIsRegistering(_ value: Bool) {
        isRegistering = value
    }
    
    func loginUser(user: User) {
        loggedInUser = UserData(name: user.name, email: user.email, isAdmin: user.isAdmin)
        isLoggedIn = true
    }

}
