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
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    private let scenario: RestaurantScenario
    private let restaurant: Restaurant?
    private let onAddCompletion: (() -> Void)?
    private let dataManager: CoreDataManager<Restaurant>
    
    var title: String {
        switch scenario {
        case .add:
            return Lingo.addEditRestaurantCreateTitle
        case .edit:
            return Lingo.addEditRestaurantEditTitle
        }
    }
    
    init(scenario: RestaurantScenario, dataManager: CoreDataManager<Restaurant>,  restaurant: Restaurant? = nil, onAddCompletion: (() -> Void)? = nil) {
        self.dataManager = dataManager
        self.onAddCompletion = onAddCompletion
        self.scenario = scenario
        self.restaurant = restaurant
        if let restaurant = restaurant {
            self.name = restaurant.name
            self.address = restaurant.address
            self.image = restaurant.image
        }
    }
    
    func addRestaurant() async {
        do {
            try await dataManager.createEntity { [weak self] (restaurant: Restaurant) in
                self?.configure(restaurant: restaurant)
            }
            await MainActor.run { [weak self] in
                self?.onAddCompletion?()
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.showingAlert = true
                self?.alertMessage = error.localizedDescription
            }
        }
    }
    
    func editRestaurant() async {
        guard let restaurant = restaurant else { return }
        restaurant.name = name
        restaurant.address = address
        restaurant.image = image
        
        do {
            try await dataManager.saveEntity(entity: restaurant)
            await MainActor.run { [weak self] in
                self?.onAddCompletion?()
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.showingAlert = true
                self?.alertMessage = error.localizedDescription
            }
        }
    }
    
    private func configure(restaurant: Restaurant) {
        restaurant.name = self.name
        restaurant.address = self.address
        restaurant.image = self.image
    }
    
}
