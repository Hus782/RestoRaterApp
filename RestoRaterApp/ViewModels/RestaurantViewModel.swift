//
//  RestaurantViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import CoreData
import SwiftUI

final class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var restaurantToDelete: Restaurant?
    @Published var showingDeleteConfirmation = false
    @Published var isLoading = false

    private let dataManager: RestaurantDataManager
    
    init(dataManager: RestaurantDataManager) {
        self.dataManager = dataManager
        Task {
            
            await fetchRestaurants()
        }
    }
    
    func fetchRestaurants() async {
        do {
            isLoading = true
            defer { isLoading = false }  // Ensures isLoading is set to false when the function exits
            let fetchedRestaurants = try await dataManager.fetchRestaurants()

            await MainActor.run {
                self.restaurants = fetchedRestaurants
            }
            
        } catch {
            print("Error fetching restaurants: \(error)")
        }
    }
    
    func promptDelete(restaurant: Restaurant) {
        restaurantToDelete = restaurant
        showingDeleteConfirmation = true
    }
    
    func deleteRestaurant(context: NSManagedObjectContext, completion: @escaping () -> Void) {
        guard let restaurant = restaurantToDelete else {
            showingAlert = true
            alertMessage = "Something went wrong"
            return
        }
        context.delete(restaurant)
        do {
            try context.save()
            completion()
        } catch {
            print("Error deleting restaurant: \(error)")
            showingAlert = true
            alertMessage = error.localizedDescription
        }
        restaurantToDelete = nil
        
    }
    
}
