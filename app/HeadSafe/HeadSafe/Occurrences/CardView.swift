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
    let number: Int
    var body: some View {
        HStack {
            if let uiImage = decodeBase64ToImage(base64String: occurrence.image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 130, height: 100)
                    .cornerRadius(3)
            } else {
                Rectangle() // Placeholder if image decoding fails
                    .frame(width: 130, height: 100)
                    .foregroundColor(.gray)
                    .cornerRadius(3)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Ocorrência \(number)")
                    .font(.custom("WorkSans-Medium", size: 16))
                Text(formatDateString(occurrence.description) ?? "")
                    .font(.custom("WorkSans-Medium", size: 14))
                    .foregroundStyle(Color(UIColor.customGray.asColor))
            }
            Spacer()
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
    
    func formatDateString(_ dateString: String) -> String? {
        // Definir o formatador de data para o formato original da string
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Evitar problemas com formatação de data
        
        // Converter a string para um objeto Date
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        // Definir o formatador de data para o formato desejado
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        // Converter a data de volta para uma string no formato desejado
        return outputFormatter.string(from: date)
    }
}

#Preview {
    CardView(occurrence: Occurrence(description: "Gutierrez - 28/08/24", image: ""), number: 1)
}
