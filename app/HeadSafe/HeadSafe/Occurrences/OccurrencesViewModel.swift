//
//  OccorrencesViewModel.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 05/09/24.
//

import SwiftUI

@MainActor
class OccurrencesViewModel: ObservableObject {
    let network = NetworkService()
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }

    
    func sendLastRequest() async {
        let now = Date()
        let formattedLastReq = formattedDate(now)
        let body = LastRequestBody(last_req: formattedLastReq)
        
        print(body)
        do {
            let response = try await network.postRequest(.post, body: body, responseType: [Occurrence].self)
            print("Response received: \(response)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
