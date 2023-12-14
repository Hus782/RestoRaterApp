//
//  RestaurantImageView.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/14/23.
//

import SwiftUI

struct RestaurantImageView: View {
    let image: Image?

    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
            }
        }
    }
}

