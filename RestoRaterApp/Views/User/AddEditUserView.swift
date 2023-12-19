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
        _viewModel = StateObject(wrappedValue: AddEditUserViewModel(scenario: scenario, dataManager: CoreDataManager<User>(), user: user, onAddCompletion: onAddCompletion))
        
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(Lingo.addEditUserName)) {
                    TextField(Lingo.addEditUserName, text: $viewModel.name)
                }
                Section(header: Text(Lingo.addEditUserEmail)) {
                    TextField(Lingo.addEditUserEmail, text: $viewModel.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                Section(header: Text(Lingo.addEditUserPassword)) {
                    SecureField(Lingo.addEditUserPassword, text: $viewModel.password)
                }
                Section(header: Text(Lingo.addEditUserAdminAccess)) {
                    Toggle(isOn: $viewModel.isAdmin) {
                        Text(Lingo.addEditUserAdminAccess)
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
                trailing: Button(Lingo.commonSave) {
                    Task {
                        await handleSave()
                    }
                }
            )
        }
    }
    
    private func handleSave() async {
        switch scenario {
        case .add:
            await viewModel.addUser()
        case .edit:
            await viewModel.editUser()
        }
        presentationMode.wrappedValue.dismiss() // Dismiss the modal view after saving
    }
}
