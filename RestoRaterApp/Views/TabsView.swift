//
//  TabsView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import SwiftUI

struct TabsView: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        TabView {
            if userManager.currentUser?.isAdmin ?? false {
                RestaurantListView().tabItem {
                    Label("Restaurants", systemImage: "fork.knife")
                }
                UsersListView().tabItem {
                    Label("Users", systemImage: "person.3.fill")
                }
                ProfileView().tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                
            } else {
                RestaurantListView().tabItem {
                    Label("Restaurants", systemImage: "list.dash")
                }
                ProfileView().tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                
            }
            
        }
    }
}
