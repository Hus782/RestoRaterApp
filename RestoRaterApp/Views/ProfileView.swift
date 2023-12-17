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
                        UserDetail(title: Lingo.profileViewNameTitle, detail: user.name)
                        UserDetail(title: Lingo.profileViewEmailTitle, detail: user.email)
                        
                        UserRoleDetail(user: user)
                        Spacer()
                        
                    } else {
                        Text(Lingo.profileViewNoUserLoggedIn)
                            .foregroundColor(.secondary)
                    }
                    
                }
                Spacer()
            }
            .padding()
            .navigationBarTitle(Lingo.profileViewTitle, displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                userManager.logoutUser()
            }) {
                Text(Lingo.profileViewLogoutButton)
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
            Text(Lingo.profileViewRoleTitle)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(user.isAdmin ? Lingo.profileViewAdminRole : Lingo.profileViewRegularUserRole)
                .fontWeight(.medium)
                .padding(5)
                .background(user.isAdmin ? Color.green : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
        }
    }
}
