//
//  RestaurantView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/11/23.
//

import SwiftUI

struct RestaurantView: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = restaurant.image?.toImage() {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
            }
            
            Text(restaurant.name)
                .font(.headline)
        
            Text(restaurant.address)
                .font(.body)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
    
}
