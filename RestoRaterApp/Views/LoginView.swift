//
//  LoginView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var userManager: UserManager
    @ObservedObject private var viewModel: LoginViewModel = LoginViewModel(dataManager: CoreDataManager<User>())
    
    var body: some View {
        VStack {
            TextField(Lingo.loginViewEmailPlaceholder, text: $viewModel.email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top, 20)
            
            Divider()
            
            SecureField(Lingo.loginViewPasswordPlaceholder, text: $viewModel.password)
                .padding(.top, 20)
            
            Divider()
            
            Button(
                action: { attemptLogin() },
                label: {
                    Text(Lingo.loginViewLoginButton)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            )
            Button(Lingo.loginViewRegisterButton, action: {
                userManager.isRegistering = true // Switch back to registration flow
            })
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text(Lingo.loginViewLoginAlertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text(Lingo.commonOk)))
            }
        }
        .padding(30)
    }
    private func attemptLogin() {
        Task {
            await viewModel.loginUser(userManager: userManager)
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
