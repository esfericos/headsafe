//
//  SplashView.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 05/09/24.
//

import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    @State private var opacity = 1.0
    var body: some View {
        VStack{
            if isActive {
                OccurrencesView()
            } else {
                VStack{
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 210, height: 210)

                    Text("Head Safe")
                        .font(.custom("WorkSans-Medium", size: 40))
                        .bold()
                }
            }
        }
        .animation(.easeInOut(duration: 1.0), value: opacity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
