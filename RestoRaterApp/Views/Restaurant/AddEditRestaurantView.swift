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
                Section(header: Text(Lingo.addEditRestaurantName)) {
                    TextField(Lingo.addEditRestaurantName, text: $viewModel.name)
                }
                Section(header: Text(Lingo.addEditRestaurantAddress)) {
                    TextField(Lingo.addEditRestaurantAddress, text: $viewModel.address)
                }
                Section(header: Text(Lingo.addEditRestaurantImage)) {
                    PhotosPicker(Lingo.addEditRestaurantSelectImage, selection: $restaurantItem, matching: .images)
                    
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
                trailing: Button(Lingo.commonSave) {
                    handleSave()
                    presentationMode.wrappedValue.dismiss() // Dismiss the modal view after saving
                }
            )
        }
        .onAppear {
            if let data = viewModel.image, let image = UIImage(data: data) {
                restaurantImage = Image(uiImage: image)
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
