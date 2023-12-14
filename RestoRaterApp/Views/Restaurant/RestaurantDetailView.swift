//
//  RestaurantDetailView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

struct RestaurantDetailView: View {
    @StateObject var viewModel: RestaurantViewModel = RestaurantViewModel()
    @State private var showingEditRestaurantView = false
    @State private var showingAddRReviewView = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var userManager: UserManager
    @State var restaurant: Restaurant
    let onAddCompletion: (() -> Void)?
    let onDeleteCompletion: (() -> Void)?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                RestaurantImageView(image: restaurant.image?.toImage())
                Text(restaurant.name)
                    .font(.largeTitle)
                Text(restaurant.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Divider()
                
                DisplayRatingView(rating: restaurant.averageRating, starSize: .medium)
                Text("Average Rating: \(restaurant.averageRating, specifier: "%.2f")")
                
                ReviewSectionView(restaurant: restaurant)
                
                if restaurant.hasReviews {
                    NavigationLink(destination: ReviewsListView(restaurant: restaurant)) {
                        Text("Show all reviews")
                    }
                    .underline()
                    .foregroundColor(.blue)
                }
                Button(action: {
                    showingAddRReviewView = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Add Review")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .shadow(radius: 3)
                }
                .padding()
                
            }
            .padding()
        }
        .navigationBarTitle("Details", displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            if userManager.currentUser?.isAdmin ?? false {
                Menu {
                    Button("Edit") {
                        showingEditRestaurantView = true
                    }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteRestaurant(restaurant: restaurant, context: viewContext)
                        onDeleteCompletion?()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        })
        .sheet(isPresented: $showingEditRestaurantView) {
            AddEditRestaurantView(scenario: .edit, restaurant: restaurant, onAddCompletion: {
                onEditCompletion()
            })
        }
        .sheet(isPresented: $showingAddRReviewView) {
            AddEditReviewView(scenario: .add, restaurant: restaurant)
        }
    }
    
    private func onEditCompletion() {
        dismiss()
        onAddCompletion?()
    }
}
