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
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel: AddEditUserViewModel
    private let scenario: UserViewScenario
    
    init(scenario: UserViewScenario, user: User? = nil, onAddCompletion: (() -> Void)? = nil) {
        self.scenario = scenario
        _viewModel = StateObject(wrappedValue: AddEditUserViewModel(scenario: scenario, user: user, onAddCompletion: onAddCompletion))
        
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $viewModel.name)
                }
                Section(header: Text("Email")) {
                    TextField("email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                Section(header: Text("Password")) {
                    SecureField("password", text: $viewModel.password)
                }
                Section(header: Text("Admin Access")) {
                    Toggle(isOn: $viewModel.isAdmin) {
                        Text("Admin Access")
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
            viewModel.addUser(context: viewContext)
        case .edit:
            viewModel.editUser(context: viewContext)
        }
    }
}
