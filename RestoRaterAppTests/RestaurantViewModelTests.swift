//
//  RestaurantViewModelTests.swift
//  RestoRaterAppTests
//
//  Created by user249550 on 12/19/23.
//

import XCTest
import CoreData
@testable import RestoRaterApp

class RestaurantViewModelTests: XCTestCase {
    var viewModel: RestaurantViewModel!
    var inMemoryContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        inMemoryContainer = PersistenceController.inMemoryContainer()
        let dataManager = CoreDataManager<Restaurant>(context: inMemoryContainer.viewContext)
        viewModel = RestaurantViewModel(dataManager: dataManager)
    }
    
    override func tearDown() {
        viewModel = nil
        inMemoryContainer = nil
        super.tearDown()
    }
    
    func testFetchRestaurants() async throws {
        try insertMockRestaurants()
        await viewModel.fetchRestaurants()
        
        XCTAssertEqual(viewModel.restaurants.count, 2)
    }
    
    func testDeleteRestaurant() async throws {
        try insertMockRestaurants()
        await viewModel.fetchRestaurants()
        let initialCount = viewModel.restaurants.count
        let restaurantToDelete = viewModel.restaurants.first!
        viewModel.promptDelete(restaurant: restaurantToDelete)
        await viewModel.deleteRestaurant(completion: {})
        await viewModel.fetchRestaurants()
        
        XCTAssertEqual(viewModel.restaurants.count, initialCount - 1, "One restaurant should be deleted")
    }
    
    func testDeleteRestaurantWithoutPrompt() async throws {
        try insertMockRestaurants()
        await viewModel.fetchRestaurants()
        await viewModel.deleteRestaurant(completion: {})
        XCTAssertEqual(viewModel.showingAlert, true)
        XCTAssertEqual(viewModel.alertMessage,  Lingo.commonErrorMessage)
        
    }
    
    private func insertMockRestaurants() throws {
        let context = inMemoryContainer.viewContext
        
        let restaurant1 = Restaurant(context: context)
        restaurant1.name = "Mock Restaurant 1"
        restaurant1.address = "123 Mock Street"
        
        let restaurant2 = Restaurant(context: context)
        restaurant2.name = "Mock Restaurant 2"
        restaurant2.address = "456 Mock Avenue"
        
        try context.save()
    }
    
}
