//
//  ReviewsListView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/14/23.
//

import SwiftUI

struct ReviewsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userManager: UserManager
    @StateObject var viewModel = AddEditReviewViewModel(scenario: .edit)
    @State private var showingAddReviewView = false
    private let restaurant: Restaurant
    @State private var reviews: [Review] = []
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(reviews, id: \.self) { review in
                    ReviewView(review: review)
                        .swipeActions {
                            if userManager.currentUser?.isAdmin ?? false {
                                Button {
                                    self.showingAddReviewView = true
                                } label: {
                                    Label(Lingo.reviewsListViewEdit, systemImage: "pencil")
                                }
                                .tint(.blue)
                                
                                Button(role: .destructive) {
                                    viewModel.promptDelete(review: review)
                                } label: {
                                    Label(Lingo.reviewsListViewDelete, systemImage: "trash")
                                }
                            }
                        }
                        .sheet(isPresented: $showingAddReviewView) {
                            AddEditReviewView(scenario: .edit, review: review, restaurant: restaurant, onAddCompletion: {
                                dismiss()
                            })
                        }
                }
            }
            .navigationTitle(restaurant.name)
        }
        .onAppear {
            if let fetchedReviews = restaurant.reviews?.allObjects as? [Review] {
                self.reviews = fetchedReviews
            }
            viewModel.onAddCompletion = {
                dismiss()
            }
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text(Lingo.reviewsListViewError), message: Text(viewModel.alertMessage), dismissButton: .default(Text(Lingo.reviewsListViewOK)))
        }
        .alert(isPresented: $viewModel.showingDeleteConfirmation) {
            Alert(
                title: Text(Lingo.reviewsListViewConfirmDelete),
                message: Text(Lingo.reviewsListViewConfirmDeleteMessage),
                primaryButton: .destructive(Text(Lingo.reviewsListViewDelete)) {
                    viewModel.deleteReview(context: viewContext, completion: {
                        dismiss()
                    })
                },
                secondaryButton: .cancel(Text(Lingo.reviewsListViewCancel))
            )
        }
    }
}
