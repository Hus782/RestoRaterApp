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
    @State private var listKey = UUID() // Used for refreshing the list
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.users, id: \.self) { user in
                    NavigationLink(destination: UserDetailsView(user: user, onAddCompletion: {
                        refreshList()
                    })) {
                        Text(user.name)
                    }
                }
                .onDelete(perform: viewModel.deleteUser)
            }.id(listKey)
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
            AddEditUserView(scenario: .add, onAddCompletion: {
                fetch()
            })
        }
        .onAppear {
            fetch()
        }
    }
    //    Used to force a refresh of the list view after editing an item
    private func refreshList() {
        listKey = UUID()
    }
    
    private func fetch() {
        viewModel.fetchUsers(context: viewContext)
    }
    
}
