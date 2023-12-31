//
//  UsersListView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/9/23.
//

import SwiftUI

struct UsersListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = UsersViewModel(dataManager: CoreDataManager<User>())
    @State private var showingAddUserView = false
    @State private var listKey = UUID() // Used for refreshing the list
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.users, id: \.self) { user in
                    NavigationLink(destination: UserDetailsView(user: user, onEditCompletion: {
                        refreshList()
                    }, onDeleteCompletion: {
                        Task {
                            await fetch()
                        }
                    })
                        .toolbar(.hidden, for: .tabBar)) {
                            UserRowView(user: user)
                        }
                }
            }.id(listKey)
                .navigationBarTitle(Lingo.usersListTitle, displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: {
                        showingAddUserView = true
                    }) {
                        Image(systemName: "plus")
                    }
                )
        }
        .sheet(isPresented: $showingAddUserView) {
            AddEditUserView(scenario: .add, onAddCompletion: {
                Task {
                    await fetch()
                }
            })
        }

    }
    //    Used to force a refresh of the list view after editing an item
    private func refreshList() {
        listKey = UUID()
    }
    
    private func fetch() async {
        await viewModel.fetchUsers()
    }
    
}
