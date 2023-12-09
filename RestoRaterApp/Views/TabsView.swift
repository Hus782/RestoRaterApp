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
                    Label("Restaurants", systemImage: "list.dash")
                }
                Text("Users").tabItem {
                    Label("Users", systemImage: "person.3.fill")
                }
                Text("Profile").tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                
            } else {
                RestaurantListView().tabItem {
                    Label("Restaurants", systemImage: "list.dash")
                }
                Text("Profile").tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                
            }
            
        }
    }
}
