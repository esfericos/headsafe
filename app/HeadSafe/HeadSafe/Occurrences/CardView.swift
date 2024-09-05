//
//  CardView.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 04/09/24.
//

import SwiftUI

import SwiftUI

struct CardView: View {
    let occurrence: Occurrence
    
    var body: some View {
        HStack {
            if let uiImage = decodeBase64ToImage(base64String: occurrence.image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 400, height: 400)
            } else {
                Rectangle() // Placeholder if image decoding fails
                    .frame(width: 400, height: 400)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(occurrence.description)
                    .font(.custom("WorkSans-Medium", size: 16))
                Text("13:45")
                    .font(.custom("WorkSans-Medium", size: 14))
            }
        }
    }
    
    // Function to decode base64 string to UIImage
    func decodeBase64ToImage(base64String: String) -> UIImage? {
        let base64 = removeNewlineAtEnd(of: base64String)
        guard let imageData = Data(base64Encoded: base64) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    func removeNewlineAtEnd(of string: String) -> String {
        var result = string
        while result.hasSuffix("\n") {
            result.removeLast()
        }
        return result
    }
}

#Preview {
    CardView(occurrence: Occurrence(description: "Gutierrez - 28/08/24", image: ""))
}
