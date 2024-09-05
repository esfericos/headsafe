//
//  APIRoute.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 04/09/24.
//

import Foundation

enum APIRoute {
    case get
    case post
    var path: String {
        switch self {
        case .get, .post:
            return "/hello"
        }
    }
    
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }

    }
}
