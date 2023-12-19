//
//  DisplayRatingView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/12/23.
//

import SwiftUI

enum StarSize {
    case small
    case medium
    case large

    var value: CGFloat {
        switch self {
        case .small:
            return 16
        case .medium:
            return 24
        case .large:
            return 40
        }
    }
}

struct DisplayRatingView: View {
    let rating: Double
    let maximumRating = 5
    let fullStarImage = Image(systemName: "star.fill")
    let halfStarImage = Image(systemName: "star.leadinghalf.filled")
    let emptyStarImage = Image(systemName: "star")
    let offColor = Color.gray
    let onColor = Color.yellow
    let starSize: StarSize
    
    init (rating: Double, starSize: StarSize = .small) {
        self.rating = rating
        self.starSize = starSize
    }
    
    var body: some View {
        HStack {
            ForEach(0..<maximumRating, id: \.self) { starIndex in
                imageForRating(Double(starIndex))
                    .resizable()
                    .frame(width: starSize.value, height: starSize.value)
                    .foregroundColor(starIndex + 1 > Int(rating + 0.5) ? offColor : onColor)
            }
        }
    }

    private func imageForRating(_ value: Double) -> Image {
        if value + 1 <= rating {
            return fullStarImage
        } else if value + 0.5 <= rating {
            return halfStarImage
        } else {
            return emptyStarImage
        }
    }
}

