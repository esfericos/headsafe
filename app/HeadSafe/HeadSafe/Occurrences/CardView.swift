//
//  CardView.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 04/09/24.
//

import SwiftUI

struct CardView: View {
    let occurrence: Occurrence
    var body: some View {
        HStack {
            occurrence.image
                .frame(width: 100, height: 100)
            VStack(alignment: .leading, spacing: 12) {
                Text(occurrence.description)
                    .font(.custom("WorkSans-Medium", size: 16))
                Text("13:45")
                    .font(.custom("WorkSans-Medium", size: 14))
            }
        }
    }
}

#Preview {
    CardView(occurrence: Occurrence(image: Image("testImage"), description: "Gutierrez - 28/08/24"))
}
