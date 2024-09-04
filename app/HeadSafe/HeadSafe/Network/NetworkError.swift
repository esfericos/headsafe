//
//  NetworkError.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 04/09/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(code: Int)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .noData:
            return "No data was returned from the server."
        case .decodingError:
            return "Failed to decode the response."
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

