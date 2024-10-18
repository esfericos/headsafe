//
//  CardView.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 04/09/24.
//

import SwiftUI

struct CardView: View {
    let occurrence: Occurrence
    let number: Int
    let isSelected: Bool

    var body: some View {
        Group {
            if isSelected {
                // Layout quando o cartão está selecionado
                VStack(alignment: .leading, spacing: 12) {
                    imageView
                    Text("Ocorrência \(number)")
                        .font(.custom("WorkSans-Medium", size: 16))
                    Text(formatDateString(occurrence.description) ?? "")
                        .font(.custom("WorkSans-Medium", size: 14))
                        .foregroundStyle(Color(UIColor.customGray.asColor))
                }
                .padding(.leading,6)

            } else {
                // Layout quando o cartão não está selecionado
                HStack {
                    imageView
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ocorrência \(number)")
                            .font(.custom("WorkSans-Medium", size: 16))
                        Text(formatDateString(occurrence.description) ?? "")
                            .font(.custom("WorkSans-Medium", size: 14))
                            .foregroundStyle(Color(UIColor.customGray.asColor))
                    }
                    Spacer()
                }
                .padding(.leading, 12)
            }
        }
    }

    // Subview para a imagem, ajustando o tamanho com base na seleção
    var imageView: some View {
        Group {
            if let uiImage = decodeBase64ToImage(base64String: occurrence.image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: isSelected ? 342 : 130, height: isSelected ? 195 : 100)
                    .cornerRadius(3)
            } else {
                Rectangle()
                    .frame(width: isSelected ? 342 : 130, height: isSelected ? 195 : 100)
                    .foregroundColor(.gray)
                    .cornerRadius(3)
            }
        }
    }

    // Função para decodificar a string base64 em UIImage
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
    CardView(occurrence: Occurrence(description: "2024-08-28 14:30", image: ""), number: 1, isSelected: false)
}
