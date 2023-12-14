//
//  UserDetailsView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import SwiftUI

struct UserDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = UsersViewModel()
    @State private var showingEditUserView = false
    @Environment(\.dismiss) private var dismiss
    let user: User 
    let onAddCompletion: (() -> Void)?
    let onDeleteCompletion: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Name: \(user.name)")
                .font(.title)

            Text("Email: \(user.email)")
                .font(.subheadline)

            Text("Role: \(user.isAdmin ? "Admin" : "Regular User")")
                .font(.subheadline)
                .foregroundColor(user.isAdmin ? .green : .blue)
                
            Button("Delete Restaurant") {
                viewModel.deleteUser(user: user, context: viewContext)
                dismiss()
                onDeleteCompletion?()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            Spacer()
        }
        .padding()
        .navigationBarTitle("Details", displayMode: .inline)
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
