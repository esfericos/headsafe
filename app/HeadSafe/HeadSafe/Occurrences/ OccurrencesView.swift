//
//   OccurrencesView.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 04/09/24.
//

import SwiftUI

struct OccurrencesView: View {
    @StateObject var vm = OccurrencesViewModel()
    @State private var selectedCardIndex: Int? = nil

    var body: some View {
        VStack {
            Text("Registro de Ocorrências")
                .font(.custom("WorkSans-Medium", size: 22))
                .padding(24)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(vm.occurrences.enumerated()), id: \.offset) { index, occurrence in
                        CardView(occurrence: occurrence, number: index + 1, isSelected: selectedCardIndex == index)
                            .onTapGesture {
                                if selectedCardIndex == index {
                                    // Desseleciona se já estiver selecionado
                                    selectedCardIndex = nil
                                } else {
                                    // Seleciona um novo cartão
                                    selectedCardIndex = index
                                }
                            }
                    }
                    
                    Text("\(vm.occurrences.count) ocorrências")
                        .font(.custom("WorkSans-Medium", size: 14))
                        .foregroundStyle(Color(UIColor.customGray.asColor))
                        .padding(.top, 20)
                }
                .padding()
            }
            .refreshable {
                Task { await vm.sendLastRequest() }
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
