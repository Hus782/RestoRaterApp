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
    
    init(review: Review, title: String = "") {
        self.review = review
        self.title = title
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if !title.isEmpty {
                    Text(title)
                        .font(.headline)
                }
                Text(review.dateVisited, formatter: dateFormatter)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                DisplayRatingView(rating: Double(review.rating))
                
                Text(review.comment)
                    .font(.body)
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
}
