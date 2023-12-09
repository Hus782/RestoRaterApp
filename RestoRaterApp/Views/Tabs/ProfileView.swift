//
//  ProfileView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user = userManager.currentUser {
                    Text("Name: \(user.name)")
                        .font(.headline)
                    
                    Text("Email: \(user.email)")
                        .font(.subheadline)
                    
                    if user.isAdmin {
                        Text("Role: Admin")
                            .foregroundColor(.green)
                    } else {
                        Text("Role: Regular User")
                            .foregroundColor(.blue)
                    }
                } else {
                    Text("No user is currently logged in.")
                }
            }
            .padding()
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                userManager.logoutUser()
            }) {
                Text("Logout")
            })
        }
    }
}
