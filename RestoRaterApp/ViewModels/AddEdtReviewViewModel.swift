//
//  AddEdtReviewViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/11/23.
//

import Foundation
import CoreData.NSManagedObjectContext

final class AddEditReviewViewModel: ObservableObject {
    var onAddCompletion: (() -> Void)?
    @Published var rating: Int = 0
    @Published var comment: String = ""
    @Published var visitDate = Date()
    private let scenario: ReviewViewScenario
    private let review: Review?
    private let restaurant: Restaurant?
    var title: String {
        switch scenario {
        case .add:
            return "Create review"
        case .edit:
            return "Edit review"
        }
    }
    
    init(scenario: ReviewViewScenario, review: Review? = nil, restaurant: Restaurant? = nil) {
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
            // Handle the error, perhaps by showing an alert
        }
    }
    
    func editReview(context: NSManagedObjectContext) {
        guard let review = review else { return }
        review.rating = rating
        review.comment = comment
        review.dateVisited = visitDate
        
        do {
            try context.save()
            onAddCompletion?() // Call the completion handler after saving
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            // Handle the error, perhaps by showing an alert
        }
    }
    
}
