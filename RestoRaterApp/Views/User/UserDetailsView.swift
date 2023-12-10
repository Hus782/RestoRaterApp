//
//  UserDetailsView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import SwiftUI

struct UserDetailsView: View {
    @State private var showingEditUserView = false
    let user: User 

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Name: \(user.name)")
                .font(.title)

            Text("Email: \(user.email)")
                .font(.subheadline)

            Text("Role: \(user.isAdmin ? "Admin" : "Regular User")")
                .font(.subheadline)
                .foregroundColor(user.isAdmin ? .green : .blue)

            Spacer()
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
            AddEditUserView(scenario: .edit, user: user)
        }
    }
}
