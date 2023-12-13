//
//  AddEditRestaurantView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/10/23.
//

import SwiftUI
import PhotosUI

enum RestaurantScenario {
    case add
    case edit
}

struct AddEditRestaurantView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: AddEditRestaurantViewModel
    @State private var restaurantItem: PhotosPickerItem?
    @State private var restaurantImage: Image?
    private let scenario: RestaurantScenario
    private let onAddCompletion: (() -> Void)?
    
    init(scenario: RestaurantScenario, restaurant: Restaurant? = nil, onAddCompletion: (() -> Void)? = nil) {
        self.scenario = scenario
        _viewModel = StateObject(wrappedValue: AddEditRestaurantViewModel(scenario: scenario, restaurant: restaurant, onAddCompletion: onAddCompletion))
        self.onAddCompletion = onAddCompletion
        
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Address", text: $viewModel.address)
                    PhotosPicker("Select image", selection: $restaurantItem, matching: .images)
                    
                    restaurantImage?
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                }
                
            }
            .onChange(of: restaurantItem, perform: { newItem  in
                Task {
                    guard let imageData = try? await newItem?.loadTransferable(type: Data.self) else {
                        return
                    }
                    if let image = UIImage(data: imageData) {
                        restaurantImage = Image(uiImage: image)
                        viewModel.image = imageData
                    }
                    
                }
            })
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
