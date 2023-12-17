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
    @Published var alertMessage = ""
    @Published var reviewToDelete: Review?
    @Published var showingDeleteConfirmation = false
    private let scenario: ReviewViewScenario
    private let review: Review?
    private let restaurant: Restaurant?
    var onAddCompletion: (() -> Void)?
    
    
    var title: String {
        switch scenario {
        case .add:
            return Lingo.addEditReviewCreateTitle
        case .edit:
            return Lingo.addEditReviewEditTitle
        }
    }
    
    init(scenario: ReviewViewScenario, review: Review? = nil, restaurant: Restaurant? = nil, onAddCompletion: (() -> Void)? = nil) {
        self.onAddCompletion = onAddCompletion
        if let review = review {
            self.rating = review.rating
            self.comment = review.comment
            self.visitDate = review.dateVisited
            self.scenario = .edit
            self.review = review
        } else {
            self.scenario = .add
            self.review = nil
        }
        self.restaurant = restaurant
    }
    
    func addReview(context: NSManagedObjectContext) {
        let review = Review(context: context)
        review.rating = rating
        review.comment = comment
        review.dateVisited = visitDate
        if let restaurant = restaurant {
            review.restaurant = restaurant
        }
        
        do {
            try context.save()
            onAddCompletion?() // Call the completion handler after saving
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            showingAlert = true
            alertMessage = error.localizedDescription
        }
    }
    
    func editReview(context: NSManagedObjectContext) {
        guard let review = review else {
            showingAlert = true
            alertMessage = "Something went wrong"
            return
        }
        review.rating = rating
        review.comment = comment
        review.dateVisited = visitDate
        
        do {
            try context.save()
            onAddCompletion?() // Call the completion handler after saving
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            showingAlert = true
            alertMessage = error.localizedDescription
        }
    }
    func promptDelete(review: Review) {
        reviewToDelete = review
        showingDeleteConfirmation = true
    }
    
    func deleteReview(context: NSManagedObjectContext, completion: @escaping () -> Void) {
        guard let review = reviewToDelete else {
            showingAlert = true
            alertMessage = "Something went wrong"
            return
        }
        
        context.delete(review)
        do {
            try context.save()
            completion()
        } catch {
            print("Error deleting restaurant: \(error)")
            showingAlert = true
            alertMessage = error.localizedDescription
        }
    }
    
}
