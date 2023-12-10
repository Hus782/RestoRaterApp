//
//  UsersListView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import SwiftUI

struct UsersListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = UsersViewModel()
    @State private var showingAddUserView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.users, id: \.self) { user in
                    NavigationLink(destination: UserDetailsView(user: user)) {
                        Text(user.name)
                    }
                }
                .onDelete(perform: viewModel.deleteUser)
            }
            .navigationBarTitle("Users")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    showingAddUserView = true
                }) {
                    Image(systemName: "plus")
                }
            )
        }
        .sheet(isPresented: $showingAddUserView) {
            AddEditUserView(scenario: .add)
        }
        .onAppear {
            viewModel.fetchUsers(context: viewContext)
        }
    }
}
