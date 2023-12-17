//
//  RegisterView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var userManager: UserManager
    
    @ObservedObject private var viewModel: RegisterViewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                TextField(Lingo.registerViewEmailPlaceholder, text: $viewModel.email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.top, 20)
                
                Divider()
                
                SecureField(Lingo.registerViewPasswordPlaceholder, text: $viewModel.password)
                    .padding(.top, 20)
                
                Divider()
                
                TextField(Lingo.registerViewNamePlaceholder, text: $viewModel.name)
                    .padding(.top, 20)
                
                Divider()
                
                Toggle(isOn: $viewModel.isAdmin) {
                    Text(Lingo.registerViewIsAdminLabel)
                }
                .padding(.top, 20)
            }
            
            Spacer()
            
            Button(
                action: { viewModel.registerUser(context: viewContext, userManager: userManager) },
                label: {
                    Text(Lingo.registerViewRegisterButton)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            )
            Button(Lingo.registerViewLoginButton, action: {
                userManager.isRegistering = false
            })
        }
        .padding(30)
    }
    
}

struct RegisterScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
