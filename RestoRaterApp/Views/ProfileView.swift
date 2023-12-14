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
        NavigationView {
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    
                    if let user = userManager.currentUser {
                        UserDetail(title: "Name", detail: user.name)
                        UserDetail(title: "Email", detail: user.email)
                        UserRoleDetail(user: user)
                        Spacer()
                        
                    } else {
                        Text("No user is currently logged in.")
                            .foregroundColor(.secondary)
                    }
                    
                }
                Spacer()
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

struct UserDetail: View {
    var title: String
    var detail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(detail)
                .font(.title2)
                .bold()
        }
    }
}

struct UserRoleDetail: View {
    var user: UserData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Role")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(user.isAdmin ? "Admin" : "Regular User")
                .fontWeight(.medium)
                .padding(5)
                .background(user.isAdmin ? Color.green : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
        }
    }
}
