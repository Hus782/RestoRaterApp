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
            if let latestReview = restaurant.latestReview {
                ReviewView(review: latestReview, title: Lingo.reviewSectionLatestReview)
            }
            if let highestRatedReview = restaurant.highestRatedReview {
                ReviewView(review: highestRatedReview, title: Lingo.reviewSectionHighestRatedReview)
            }
            if let lowestRatedReview = restaurant.lowestRatedReview {
                ReviewView(review: lowestRatedReview, title: Lingo.reviewSectionLowestRatedReview)
            }
        }
    }
}

