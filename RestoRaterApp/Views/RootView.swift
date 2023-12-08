//
//  RootView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        if userManager.isLoggedIn {
            RestaurantListView() 
        } else if userManager.isRegistering {
            RegisterView()
        } else {
            LoginView()
        }
    }
}

