//
//  RestaurantListView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

struct RestaurantListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: RestaurantViewModel = RestaurantViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.restaurants, id: \.self) { restaurant in
                Text(restaurant.name)
            }
            .navigationBarTitle("Restaurants")
        }
        .onAppear {
            viewModel.fetchRestaurants(context: viewContext)
        }
    }
}
