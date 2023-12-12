//
//  ReviewView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/8/23.
//

import SwiftUI

struct ReviewView: View {
    let review: Review
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            DisplayRatingView(rating: Double(review.rating))
            Text("Rating: \(review.rating)/5")
            Text("Visited on: \(review.dateVisited, formatter: dateFormatter)")
                                .font(.subheadline)
            Text(review.comment)
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
