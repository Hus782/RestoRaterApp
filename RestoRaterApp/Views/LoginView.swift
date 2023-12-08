//
//  LoginView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var userManager: UserManager
    @ObservedObject private var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top, 20)
            
            Divider()
            
            SecureField("Password", text: $viewModel.password)
                .padding(.top, 20)
            
            Divider()
            
            Button(
                action: { viewModel.loginUser(context: viewContext) },
                label: {
                    Text("Login")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            )
            Button("Register", action: {
                userManager.isRegistering = true // Switch back to registration flow
            })
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text("Login"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding(30)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
