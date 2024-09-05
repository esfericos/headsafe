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
    @Published var occurrences: [Occurrence] = []
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }

    func sendLastRequest() async {
        let now = Date()
//        let formattedLastReq = formattedDate(now)
        let formattedLastReq = "2024-09-05 17:30"
        let body = LastRequestBody(last_req: formattedLastReq)
        
        do {
            let response = try await network.postRequest(.post, body: body, responseType: [Occurrence].self)
//            OccurrenceDataManager.saveOccurrences(response)
//            occurrences = OccurrenceDataManager.loadOccurrences() ?? []
            print(response)
            occurrences = response
            
            print(occurrences[0].image)
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    

    
    func decodeBase64ToImage(base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
