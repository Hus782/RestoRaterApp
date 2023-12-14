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
                
                Button("Add Review") {
                    showingAddRReviewView = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
                
                Button("Delete Restaurant") {
                    viewModel.deleteRestaurant(restaurant: restaurant, context: viewContext)
                    dismiss()
                    onDeleteCompletion?()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
                
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
