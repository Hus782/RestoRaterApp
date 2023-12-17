//
//  UserDetailsView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import SwiftUI

struct UserDetailsView: View {
    @EnvironmentObject private var userManager: UserManager
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = UsersViewModel()
    @State private var showingEditUserView = false
    @Environment(\.dismiss) private var dismiss
    let user: User
    let onAddCompletion: (() -> Void)?
    let onDeleteCompletion: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(Lingo.userDetailsNameLabel) \(user.name)")
                        .font(.title2)
                        .bold()
                    
                    Text("\(Lingo.userDetailsEmailLabel) \(user.email)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(Lingo.userDetailsRoleLabel)
                        Text(user.isAdmin ? Lingo.userDetailsRoleAdmin : Lingo.userDetailsRoleRegularUser)
                            .fontWeight(.medium)
                            .padding(5)
                            .background(user.isAdmin ? Color.green : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            if !userManager.isCurrentUser(user: user) {
                Button(Lingo.commonDelete) {
                    viewModel.promptDelete(user: user)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
            }
        }
        .padding()
        .navigationBarTitle(Lingo.userDetailsTitle, displayMode: .inline)
        .navigationBarItems(
            trailing: Button(action: {
                showingEditUserView = true
            }) {
                Text(Lingo.commonEdit)
            }
        )
        .sheet(isPresented: $showingEditUserView) {
            AddEditUserView(scenario: .edit, user: user, onAddCompletion: {
                onEditCompletion()
            })
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text(Lingo.userDetailsErrorAlert), message: Text(viewModel.alertMessage), dismissButton: .default(Text(Lingo.commonOk)))
        }
        .alert(isPresented: $viewModel.showingDeleteConfirmation) {
            Alert(
                title: Text(Lingo.commonConfirmDelete),
                message: Text("Are you sure you want to delete this user?"),
                primaryButton: .destructive(Text(Lingo.commonDelete)) {
                    viewModel.deleteUser(context: viewContext, completion: {
                        dismiss()
                        onDeleteCompletion?()
                    })
                },
                secondaryButton: .cancel(Text(Lingo.commonCancel))
            )
        }
    }
    
    private func onEditCompletion() {
        dismiss()
        onAddCompletion?()
    }
}
