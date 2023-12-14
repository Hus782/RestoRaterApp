//
//  AddEditRestaurantViewModel.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/10/23.
//

import Foundation
import CoreData.NSManagedObjectContext

final class AddEditRestaurantViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var image: Data?
    private let scenario: RestaurantScenario
    private let restaurant: Restaurant?
    private let onAddCompletion: (() -> Void)?

    
    var title: String {
        switch scenario {
        case .add:
            return "Create restaurant"
        case .edit:
            return "Edit restaurant"
        }
    }
    
    init(scenario: RestaurantScenario, restaurant: Restaurant? = nil, onAddCompletion: (() -> Void)? = nil) {
        self.onAddCompletion = onAddCompletion
        if let restaurant = restaurant {
            self.name = restaurant.name
            self.address = restaurant.address
            self.image = restaurant.image
            self.scenario = .edit
            self.restaurant = restaurant
        } else {
            self.scenario = .add
            self.restaurant = nil
        }
    }
    
    func addRestaurant(context: NSManagedObjectContext) {
        let restaurant = Restaurant(context: context)
        restaurant.name = name
        restaurant.address = address
        if let image = image {
            restaurant.image = image
        }
        
        do {
            try context.save()
            onAddCompletion?() // Call the completion handler after saving
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            // Handle the error, perhaps by showing an alert
        }
    }
    
    func editRestaurant(context: NSManagedObjectContext) {
        guard let restaurant = restaurant else { return }
        restaurant.name = name
        restaurant.address = address
        if let image = image {
            restaurant.image = image
        }
        
        do {
            try context.save()
            onAddCompletion?() // Call the completion handler after saving
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
            // Handle the error, perhaps by showing an alert
        }
    }
    
}
