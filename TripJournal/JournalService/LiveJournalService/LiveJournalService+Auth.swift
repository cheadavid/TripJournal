//
//  LiveJournalService+Auth.swift
//  TripJournal
//
//  Created by David Chea on 24/08/2025.
//

import SwiftUI
import Combine

extension LiveJournalService {
    
    // MARK: - Properties
    
    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Methods
    
    func register(username: String, password: String) async throws -> Token {
        let url = baseURL.appendingPathComponent("register")
        
        let requestBody = UserCreate(username: username, password: password)
        let jsonData = try JSONEncoder().encode(requestBody)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, _) = try await session.data(for: request)
        let token = try JSONDecoder().decode(Token.self, from: data)
        
        self.token = token
        
        return token
    }
    
    func logIn(username: String, password: String) async throws -> Token {
        let url = baseURL.appendingPathComponent("token")
        
        var formComponents = URLComponents()
        formComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: ""),
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password)
        ]
        
        let formData = formComponents.percentEncodedQuery!.data(using: .utf8)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = formData
        
        let (data, _) = try await session.data(for: request)
        let token = try JSONDecoder().decode(Token.self, from: data)
        
        self.token = token
        
        return token
    }
    
    func logOut() {
        token = nil
    }
}
