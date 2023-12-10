//
//  AddEditRestaurantView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/10/23.
//

import SwiftUI

enum RestaurantScenario {
    case add
    case edit
}

struct AddEditRestaurantView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: AddEditRestaurantViewModel
    private let scenario: RestaurantScenario
    var onAddCompletion: (() -> Void)?
    
    init(scenario: RestaurantScenario, restaurant: Restaurant? = nil) {
        self.scenario = scenario
        _viewModel = StateObject(wrappedValue: AddEditRestaurantViewModel(scenario: scenario, restaurant: restaurant))

    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Address", text: $viewModel.address)
                    TextField("Image", text: $viewModel.image)
                }
                
            }
            .navigationBarTitle(viewModel.title, displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss the modal view
                }) {
                    Image(systemName: "xmark")
                },
                trailing: Button("Save") {
                    handleSave()
                    presentationMode.wrappedValue.dismiss() // Dismiss the modal view after saving
                }
            )
            .onAppear {

            }
        }
    }
    
    private func handleSave() {
        switch scenario {
        case .add:
            viewModel.addRestaurant(context: viewContext)
        case .edit:
            viewModel.editRestaurant(context: viewContext)
        }
    }
}
