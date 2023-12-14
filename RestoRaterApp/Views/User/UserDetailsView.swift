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
                    Text("Name: \(user.name)")
                        .font(.title2)
                        .bold()
                    
                    Text("Email: \(user.email)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Role:")
                        Text(user.isAdmin ? "Admin" : "Regular User")
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
//            Prevent the admin from self deleting
            if !userManager.isCurrentUser(user: user) {
                Button("Delete User") {
                    viewModel.deleteUser(user: user, context: viewContext)
                    dismiss()
                    onDeleteCompletion?()
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
        
        .navigationBarTitle("User Details", displayMode: .inline)
        .navigationBarItems(
            trailing: Button(action: {
                showingEditUserView = true
            }) {
                Text("Edit")
            }
        )
        .sheet(isPresented: $showingEditUserView) {
            AddEditUserView(scenario: .edit, user: user, onAddCompletion: {
                onEditCompletion()
            })
        }
    }
    
    private func onEditCompletion() {
        dismiss()
        onAddCompletion?()
    }
}

