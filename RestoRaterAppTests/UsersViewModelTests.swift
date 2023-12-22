//
//  UsersViewModelTests.swift
//  RestoRaterAppTests
//
//  Created by user249550 on 12/20/23.
//

import XCTest
import CoreData
@testable import RestoRaterApp

class UsersViewModelTests: XCTestCase {
    var viewModel: UsersViewModel!
    var inMemoryContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        inMemoryContainer = PersistenceController.inMemoryContainer()
        let dataManager = CoreDataManager<User>(context: inMemoryContainer.viewContext)
        viewModel = UsersViewModel(dataManager: dataManager)
    }
    
    override func tearDown() {
        viewModel = nil
        inMemoryContainer = nil
        super.tearDown()
    }
    
    func testFetchUsers() async throws {
        try insertMockUsers()
        await viewModel.fetchUsers()
        
        XCTAssertEqual(viewModel.users.count, 2, "There should be 2 mock users")
    }
    
    func testDeleteUser() async throws {
        try insertMockUsers()
        await viewModel.fetchUsers()
        let initialCount = viewModel.users.count
        let userToDelete = viewModel.users.first!
        viewModel.promptDelete(user: userToDelete)
        await viewModel.deleteUser(completion: {})
        await viewModel.fetchUsers()
        
        XCTAssertEqual(viewModel.users.count, initialCount - 1, "One user should be deleted")
    }
    
    func testDeleteUserWithoutPrompt() async throws {
        try insertMockUsers()
        await viewModel.fetchUsers()
        await viewModel.deleteUser(completion: {})
        XCTAssertEqual(viewModel.showingAlert, true, "Alert should be shown when deleting without prompt")
        XCTAssertEqual(viewModel.alertMessage, "Something went wrong", "Appropriate error message should be displayed")
    }
    
    private func insertMockUsers() throws {
        let context = inMemoryContainer.viewContext
        
        let user1 = User(context: context)
        user1.name = "Mock User 1"
        user1.email = "mock1@example.com"
        user1.password = "123"
        user1.isAdmin = false
        
        let user2 = User(context: context)
        user2.name = "Mock User 2"
        user2.email = "mock2@example.com"
        user2.password = "123"
        user2.isAdmin = false
        
        try context.save()
    }
}
