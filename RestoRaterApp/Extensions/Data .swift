//
//  Data .swift
//  RestoRaterApp
//
//  Created by user249550 on 12/11/23.
//

import SwiftUI

extension Data {
    func toImage() -> Image? {
        if let uiImage = UIImage(data: self) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}
