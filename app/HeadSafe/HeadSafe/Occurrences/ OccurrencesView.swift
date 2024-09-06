//
//   OccurrencesView.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 04/09/24.
//

import SwiftUI

struct OccurrencesView: View {
    @StateObject var vm = OccurrencesViewModel()

    var body: some View {
        VStack {
            Text("Registro de Ocorrências")
                .font(.custom("WorkSans-Medium", size: 22))
                .padding(24)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(vm.occurrences.enumerated()), id: \.offset) { index, occurrence in
                        CardView(occurrence: occurrence, number: index + 1)
                    }
                    
                    Text("\(vm.occurrences.count) ocorrências")
                        .font(.custom("WorkSans-Medium", size: 14))
                        .foregroundStyle(Color(UIColor.customGray.asColor))
                        .padding(.top, 20)
                }
                .padding()
            }
            
            Spacer()
        }
        .onAppear() {
            Task { await vm.sendLastRequest() }
        }
    }
}

#Preview {
    OccurrencesView()
}
