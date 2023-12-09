//
//  AddEditUserView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import SwiftUI

enum UserViewScenario {
    case add
    case edit
}

struct AddEditUserView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AddEditUserViewModel()
    private let scenario: UserViewScenario
    var onAddCompletion: (() -> Void)?
    
    init(scenario: UserViewScenario) {
        self.scenario = scenario
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $viewModel.name)
                    TextField("email", text: $viewModel.email)
                    TextField("password", text: $viewModel.password)
                    Toggle(isOn: $viewModel.isAdmin) {
                        Text("Is Admin")
                    }
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
                    viewModel.addUser(context: viewContext)
                    presentationMode.wrappedValue.dismiss() // Dismiss the modal view after saving
                }
            )
            .onAppear {
                viewModel.scenario = scenario
            }
        }
    }
    
}
