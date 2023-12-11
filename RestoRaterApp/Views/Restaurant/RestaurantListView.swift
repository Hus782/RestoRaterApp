//
//  RestaurantListView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

struct RestaurantListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddRestaurantView = false
    @ObservedObject var viewModel: RestaurantViewModel = RestaurantViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.restaurants, id: \.self) { restaurant in
                NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                    Text(restaurant.name)
                }

            }
            .navigationBarTitle("Restaurants", displayMode: .inline)
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    showingAddRestaurantView = true
                }) {
                    Image(systemName: "plus")
                }
            )
        }
        .onAppear {
            viewModel.fetchRestaurants(context: viewContext)
        }
        .sheet(isPresented: $showingAddRestaurantView) {
            AddEditRestaurantView(scenario: .add)
        }
    }
}
