//
//  RestaurantListView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

struct RestaurantListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var userManager: UserManager
    @State private var showingAddRestaurantView = false
    @State private var listKey = UUID() // Used for refreshing the list
    @StateObject var viewModel: RestaurantViewModel = RestaurantViewModel(dataManager: RestaurantDataManager())
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                            ProgressView() // Show spinner while loading
                                .progressViewStyle(CircularProgressViewStyle())
            } else {
                List(viewModel.restaurants, id: \.self) { restaurant in
                    RestaurantView(restaurant: restaurant)
                        .listRowSeparator(.hidden)
                    //  Doing this to remove the right arrow generated by NavigationLink for some reason
                        .background(
                            NavigationLink("", destination:  RestaurantDetailView(restaurant: restaurant, onAddCompletion: {
                                refreshList()
                            }, onDeleteCompletion: {
                                Task {
                                    await fetch()
                                }
                            }).toolbar(.hidden, for: .tabBar)
                                          )
                            .opacity(0))
                }.id(listKey)
                    .listStyle(PlainListStyle())
                    .navigationBarTitle(Lingo.restaurantsListTitle, displayMode: .inline)
                    .navigationBarItems(
                        trailing: Button(action: {
                            showingAddRestaurantView = true
                        }) {
                            if userManager.currentUser?.isAdmin ?? false {
                                Image(systemName: "plus")
                            }
                        }
                    )
            }
        }
//        .onAppear {
//            Task {
//                await fetch()
//            }
//        }
        .sheet(isPresented: $showingAddRestaurantView) {
            AddEditRestaurantView(scenario: .add, onAddCompletion: {
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
        await viewModel.fetchRestaurants()
    }
}
