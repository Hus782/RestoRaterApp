//
//  RegisterView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: RegisterViewModel = RegisterViewModel()

    var body: some View {
        VStack {
            Spacer()

            VStack {
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.top, 20)
                
                Divider()
                
                SecureField("Password", text: $viewModel.password)
                    .padding(.top, 20)
                
                Divider()
                
                TextField("Name", text: $viewModel.name)
                    .padding(.top, 20)
                
                Divider()

                Toggle(isOn: $viewModel.isAdmin) {
                    Text("Is Admin")
                }
                .padding(.top, 20)
            }

            Spacer()

            Button(
                action: { viewModel.registerUser(context: viewContext) },
                label: {
                    Text("Register")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            )
        }
        .padding(30)
    }
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
