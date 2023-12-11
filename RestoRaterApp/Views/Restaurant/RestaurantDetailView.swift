//
//  RestaurantDetailView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

struct RestaurantDetailView: View {
    @State private var showingEditRestaurantView = false
    @State private var showingAddRReviewView = false
    let restaurant: Restaurant

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let image = restaurant.image?.toImage() {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                }

                Text(restaurant.name)
                    .font(.largeTitle)

                Text(restaurant.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Divider()

                Text("Average Rating: \(restaurant.averageRating, specifier: "%.2f")")

                // Highest Rated Review
                if let highestRatedReview = restaurant.highestRatedReview {
                    ReviewView(review: highestRatedReview, title: "Highest Rated Review")
                }

                // Lowest Rated Review
                if let lowestRatedReview = restaurant.lowestRatedReview {
                    ReviewView(review: lowestRatedReview, title: "Lowest Rated Review")
                }

                // Latest Review
                if let latestReview = restaurant.latestReview {
                    ReviewView(review: latestReview, title: "Latest Review")
                }
                
                Button("Add Review") {
                    showingAddRReviewView = true
                }
            }
            .padding()
        }
        .navigationBarTitle("Restaurant Details", displayMode: .inline)
        .navigationBarItems(
            trailing: Button(action: {
                showingEditRestaurantView = true
            }) {
                Text("Edit")
            }
        )
        .sheet(isPresented: $showingEditRestaurantView) {
            AddEditRestaurantView(scenario: .edit, restaurant: restaurant)
        }
        .sheet(isPresented: $showingAddRReviewView) {
            AddEditReviewView(scenario: .add, restaurant: restaurant)
        }
    }
    
}
