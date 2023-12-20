//
//  AddEditReviewViewModelTests.swift
//  RestoRaterAppTests
//
//  Created by user249550 on 12/20/23.
//

import XCTest
import CoreData
@testable import RestoRaterApp

class AddEditReviewViewModelTests: XCTestCase {
    var viewModel: AddEditReviewViewModel!
    var inMemoryContainer: NSPersistentContainer!
    var dataManager: CoreDataManager<Review>!
    
    override func setUp() {
        super.setUp()
        inMemoryContainer = PersistenceController.inMemoryContainer()
        dataManager = CoreDataManager<Review>(context: inMemoryContainer.viewContext)
    }
    
    override func tearDown() {
        viewModel = nil
        inMemoryContainer = nil
        dataManager = nil
        super.tearDown()
    }
    
    func testInitializationForAddScenario() throws {
        viewModel = AddEditReviewViewModel(scenario: .add, dataManager: dataManager)

        XCTAssertEqual(viewModel.rating, 0, "Rating should be 0 for add scenario")
        XCTAssertEqual(viewModel.comment, "", "Comment should be empty for add scenario")
        XCTAssertEqual(viewModel.title, Lingo.addEditReviewCreateTitle, "Title should be correct for add scenario")
    }

    func testInitializationForEditScenario() throws {
        let mockReview = Review(context: inMemoryContainer.viewContext)
        mockReview.rating = 5
        mockReview.comment = "Mock Comment"
        mockReview.dateVisited = Date()

        viewModel = AddEditReviewViewModel(scenario: .edit, dataManager: dataManager, review: mockReview)

        XCTAssertEqual(viewModel.rating, 5, "Rating should be set for edit scenario")
        XCTAssertEqual(viewModel.comment, "Mock Comment", "Comment should be set for edit scenario")
        XCTAssertEqual(viewModel.title, Lingo.addEditReviewEditTitle, "Title should be correct for edit scenario")
    }

    func testAddReview() async throws {
        viewModel = AddEditReviewViewModel(scenario: .add, dataManager: dataManager)
        viewModel.rating = 4
        viewModel.comment = "New Review Comment"
        viewModel.visitDate = Date()

        await viewModel.addReview()

        let fetchRequest: NSFetchRequest<Review> = Review.createFetchRequest()
        let results = try inMemoryContainer.viewContext.fetch(fetchRequest)
        XCTAssertEqual(results.count, 1, "One review should be added")
        XCTAssertEqual(results.first?.comment, "New Review Comment", "The review comment should match")
    }

    func testEditReview() async throws {
        let mockReview = Review(context: inMemoryContainer.viewContext)
        mockReview.rating = 3
        mockReview.comment = "Mock Comment"
        mockReview.dateVisited = Date()

        viewModel = AddEditReviewViewModel(scenario: .edit, dataManager: dataManager, review: mockReview)
        viewModel.rating = 5
        viewModel.comment = "Updated Comment"
        viewModel.visitDate = Date()

        await viewModel.editReview()

        XCTAssertEqual(mockReview.rating, 5, "The review rating should be updated")
        XCTAssertEqual(mockReview.comment, "Updated Comment", "The comment should be updated")
    }

    func testDeleteReview() async throws {
        let mockReview = Review(context: inMemoryContainer.viewContext)
        mockReview.rating = 4
        mockReview.comment = "Mock Comment"
        mockReview.dateVisited = Date()

        viewModel = AddEditReviewViewModel(scenario: .edit, dataManager: dataManager, review: mockReview)
        viewModel.promptDelete(review: mockReview)
        await viewModel.deleteReview(completion: {})

        let fetchRequest: NSFetchRequest<Review> = Review.createFetchRequest()
        let results = try inMemoryContainer.viewContext.fetch(fetchRequest)
        XCTAssertEqual(results.isEmpty, true, "The review should be deleted")
    }
}
