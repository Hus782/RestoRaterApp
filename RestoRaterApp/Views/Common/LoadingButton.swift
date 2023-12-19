//
//  LoadingButton.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/19/23.
//

import SwiftUI

struct LoadingButton: View {
    @Binding var isLoading: Bool
    let title: String
    let action: () async -> Void

    var body: some View {
        if isLoading {
            ProgressView()
        } else {
            Button(title) {
                Task {
                    await action()
                }
            }
        }
    }
}
