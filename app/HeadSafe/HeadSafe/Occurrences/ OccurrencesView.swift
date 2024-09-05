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
