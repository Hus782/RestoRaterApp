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
    
    func fetchRestaurants(context: NSManagedObjectContext) {
        let request: NSFetchRequest<Restaurant> = Restaurant.createFetchRequest()
        
        do {
            restaurants = try context.fetch(request)
        } catch {
            print("Error fetching restaurants: \(error)")
        }
    }
    
    func deleteRestaurant(restaurant: Restaurant, context: NSManagedObjectContext) {
        context.delete(restaurant)
        
        do {
            try context.save()
        } catch {
            print("Error deleting restaurant: \(error)")
        }
    }
    
}
