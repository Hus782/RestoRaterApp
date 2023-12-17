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
                                    Label(Lingo.commonEdit, systemImage: "pencil")
                                }
                                .tint(.blue)
                                
                                Button(role: .destructive) {
                                    viewModel.promptDelete(review: review)
                                } label: {
                                    Label(Lingo.commonDelete, systemImage: "trash")
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
            Alert(title: Text(Lingo.reviewsListViewError), message: Text(viewModel.alertMessage), dismissButton: .default(Text(Lingo.commonOk)))
        }
        .alert(isPresented: $viewModel.showingDeleteConfirmation) {
            Alert(
                title: Text(Lingo.commonConfirmDelete),
                message: Text(Lingo.reviewsListViewConfirmDeleteMessage),
                primaryButton: .destructive(Text(Lingo.commonDelete)) {
                    viewModel.deleteReview(context: viewContext, completion: {
                        dismiss()
                    })
                },
                secondaryButton: .cancel(Text(Lingo.commonCancel))
            )
        }
    }
}
