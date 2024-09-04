//
//  NetworkService.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 04/09/24.
//

import Foundation

class NetworkService {
    
    private let baseURL = "http://35.170.158.159:3030/"
    
    // GET
    func request<T: Decodable>(_ route: APIRoute, responseType: T.Type) async throws -> T {
        guard let url = URL(string: baseURL + route.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = route.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(code: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // POST
    func postRequest<T: Decodable, U: Encodable>(_ route: APIRoute, body: U, responseType: T.Type) async throws -> T {
        guard let url = URL(string: baseURL + route.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = route.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.decodingError
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(code: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
}
