//
//  RestaurantViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

final class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var restaurantToDelete: Restaurant?
    @Published var showingDeleteConfirmation = false
    @Published var isLoading = false
    private let dataManager: CoreDataManager<Restaurant>
    
    init(dataManager: CoreDataManager<Restaurant>) {
        self.dataManager = dataManager
        Task {
            await fetchRestaurants()
        }
    }
    
    func fetchRestaurants() async {
        do {
            await MainActor.run { [weak self] in
                self?.isLoading = true
            }

            let fetchedRestaurants = try await dataManager.fetchEntities()
            await MainActor.run { [weak self] in
                self?.restaurants = fetchedRestaurants
                self?.isLoading = false
            }
            
        } catch {
            await MainActor.run { [weak self] in
                self?.isLoading = false
                self?.showingAlert = true
                self?.alertMessage = error.localizedDescription
            }
        }
    }
    
    func promptDelete(restaurant: Restaurant) {
        restaurantToDelete = restaurant
        showingDeleteConfirmation = true
    }
    
    func deleteRestaurant(completion: @escaping () -> Void) async {
         guard let restaurant = restaurantToDelete else {
             await MainActor.run { [weak self] in
                 self?.showingAlert = true
                 self?.alertMessage = Lingo.commonErrorMessage
             }
             return
         }
         
         do {
             try await dataManager.deleteEntity(entity: restaurant)
             await MainActor.run {
                 completion()
             }
         } catch {
             await MainActor.run { [weak self] in
                 self?.showingAlert = true
                 self?.alertMessage = error.localizedDescription
             }
         }
     }
    
}
