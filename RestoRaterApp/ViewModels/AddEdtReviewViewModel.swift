//
//  AddEdtReviewViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/11/23.
//

import Foundation
import CoreData.NSManagedObjectContext

final class AddEditReviewViewModel: ObservableObject {
    @Published var rating: Int = 0
    @Published var comment: String = ""
    @Published var visitDate = Date()
    @Published var showingAlert = false
    @Published var isLoading = false
    @Published var alertMessage = ""
    @Published var reviewToDelete: Review?
    @Published var showingDeleteConfirmation = false
    private let scenario: ReviewViewScenario
    private let review: Review?
    private let restaurant: Restaurant?
    var onAddCompletion: (() -> Void)?
    private let dataManager: CoreDataManager<Review>
    
    var title: String {
        switch scenario {
        case .add:
            return Lingo.addEditReviewCreateTitle
        case .edit:
            return Lingo.addEditReviewEditTitle
        }
    }
    
    init(scenario: ReviewViewScenario, dataManager: CoreDataManager<Review>, review: Review? = nil, restaurant: Restaurant? = nil, onAddCompletion: (() -> Void)? = nil) {
        self.onAddCompletion = onAddCompletion
        self.scenario = .edit
        self.review = review
        self.restaurant = restaurant
        self.dataManager = dataManager
        if let review = review {
            self.rating = review.rating
            self.comment = review.comment
            self.visitDate = review.dateVisited
        }
    }
    
    private func configure(review: Review) {
        review.rating = rating
        review.comment = comment
        review.dateVisited = visitDate
        if let restaurant = restaurant {
            review.restaurant = restaurant
        }
    }
    
    func addReview() async {
        do {
            try await dataManager.createEntity { [weak self] (review: Review) in
                self?.configure(review: review)
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
    
    func editReview() async {
        guard let review = review else { return }
        configure(review: review)
        do {
            try await dataManager.saveEntity(entity: review)
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
    
    func promptDelete(review: Review) {
        reviewToDelete = review
        showingDeleteConfirmation = true
    }
    
    func deleteReview(completion: @escaping () -> Void) async {
        guard let review = reviewToDelete else {
             await MainActor.run { [weak self] in
                 self?.showingAlert = true
                 self?.alertMessage = "Something went wrong"
             }
             return
         }
         
         do {
             try await dataManager.deleteEntity(entity: review)
             await MainActor.run {
                 completion()
             }
         } catch {
             await MainActor.run { [weak self] in
                 self?.showingAlert = true
                 self?.alertMessage = error.localizedDescription
             }
         }
     }

}
