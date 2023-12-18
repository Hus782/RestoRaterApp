//
//  RestaurantDataManager.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/18/23.
//

import Foundation
import CoreData

final class RestaurantDataManager {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func fetchRestaurants() async throws -> [Restaurant] {
        let request: NSFetchRequest<Restaurant> = Restaurant.createFetchRequest()
        return try await context.perform {
            try self.context.fetch(request)
        }
    }

    func addRestaurant(name: String, address: String, image: Data?) async throws {
        let newRestaurant = Restaurant(context: context)
        newRestaurant.name = name
        newRestaurant.address = address
        newRestaurant.image = image

        try await saveContext()
    }

    func deleteRestaurant(_ restaurant: Restaurant) async throws {
        context.delete(restaurant)
        try await saveContext()
    }

    private func saveContext() async throws {
        if context.hasChanges {
            try await context.perform {
                try self.context.save()
            }
        }
    }

}
