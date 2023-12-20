//
//  LoginViewModelTests.swift
//  RestoRaterAppTests
//
//  Created by user249550 on 12/20/23.
//

import XCTest
import CoreData
@testable import RestoRaterApp

class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockUserManager: MockUserManager!
    var inMemoryContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        // Setup an in-memory CoreData container for testing
        inMemoryContainer = PersistenceController.inMemoryContainer()
        let dataManager = CoreDataManager<User>(context: inMemoryContainer.viewContext)
        
        mockUserManager = MockUserManager()
        viewModel = LoginViewModel(dataManager: dataManager, userManager: mockUserManager)
    }

    override func tearDown() {
        viewModel = nil
        mockUserManager = nil
        inMemoryContainer = nil
        super.tearDown()
    }

    func testLoginSuccess() async {
        // Create a mock user and add it to the mock data manager
        let mockUser = User(context: inMemoryContainer.viewContext)
        mockUser.email = "test@example.com"
        mockUser.password = "password"
        mockUser.isAdmin = false
 
        try? inMemoryContainer.viewContext.save()

        viewModel.email = "test@example.com"
        viewModel.password = "password"
        mockUserManager.isLoginSuccess = true
        mockUserManager.isCurrent = true
        
        await viewModel.loginUser()
        
        XCTAssertTrue(viewModel.loginSuccessful)
        XCTAssertTrue(mockUserManager.isCurrentUser(user: mockUser))
        XCTAssertFalse(viewModel.showingAlert)
    }

    func testLoginInvalidCredentials() async {
        // Create a mock user and add it to the mock data manager
        let mockUser = User(context: inMemoryContainer.viewContext)
        mockUser.email = "test@example.com"
        mockUser.password = "password"
        mockUser.isAdmin = false
 
        try? inMemoryContainer.viewContext.save()

        viewModel.email = "test@example.com"
        viewModel.password = "invalid password"
        mockUserManager.isLoginSuccess = false
        
        await viewModel.loginUser()
        
        XCTAssertFalse(viewModel.loginSuccessful)
        XCTAssertEqual(viewModel.alertMessage,  Lingo.invalidCredentials)
        XCTAssertTrue(viewModel.showingAlert)
    }
    
    func testLoginNavigateToRegister() {
        viewModel.navigateToRegister()
        XCTAssertTrue(mockUserManager.isRegistering)
        
    }
}
