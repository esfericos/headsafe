//
//  Occurrence.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 04/09/24.
//

import SwiftUI


struct Occurrence: Decodable, Encodable {
    let description: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case description = "date_taken"
        case image = "image_content"
    }
}
