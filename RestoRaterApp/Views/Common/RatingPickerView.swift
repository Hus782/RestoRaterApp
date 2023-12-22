//
//  RatingView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/12/23.
//

import SwiftUI

struct RatingPickerView: View {
    @Binding var rating: Int

    let maximumRating = 5
    let image = Image(systemName: "star.fill")
    let offColor = Color.gray
    let onColor = Color.yellow
    
    var body: some View {

        HStack {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                Button {
                    rating = number
                } label: {
                    image
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
            }
        }.buttonStyle(.plain)
    }
}
