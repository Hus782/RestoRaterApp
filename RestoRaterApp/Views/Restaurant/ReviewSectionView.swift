//
//  ReviewSectionView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/14/23.
//

import SwiftUI

struct ReviewSectionView: View {
    @StateObject var restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Latest Review
            if let latestReview = restaurant.latestReview {
                ReviewView(review: latestReview, title: "Latest Review")
            }
            // Highest Rated Review
            if let highestRatedReview = restaurant.highestRatedReview {
                ReviewView(review: highestRatedReview, title: "Highest Rated Review")
            }
            // Lowest Rated Review
            if let lowestRatedReview = restaurant.lowestRatedReview {
                ReviewView(review: lowestRatedReview, title: "Lowest Rated Review")
            }
        }
    }
}
