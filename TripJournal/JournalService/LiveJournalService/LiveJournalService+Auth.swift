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
        let requestBody = UserCreate(username: username, password: password)
        let jsonData = try JSONEncoder().encode(requestBody)
        
        let request = try makeRequest(path: "register", method: "POST", body: jsonData, requiresAuth: false)
        let (data, _) = try await session.data(for: request)
        
        do {
            let token = try JSONDecoder().decode(Token.self, from: data)
            self.token = token
            
            return token
        } catch {
            if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
                throw apiError
            }
            
            throw error
        }
    }
    
    func logIn(username: String, password: String) async throws -> Token {
        var formComponents = URLComponents()
        formComponents.queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password)
        ]
        
        guard let formData = formComponents.percentEncodedQuery?.data(using: .utf8) else {
            struct FormDataError: LocalizedError {
                var errorDescription: String? { "Unable to create form data" }
            }
            
            throw FormDataError()
        }
        
        let request = try makeRequest(path: "token", method: "POST", body: formData, requiresAuth: false, contentType: "application/x-www-form-urlencoded")
        let (data, _) = try await session.data(for: request)
        
        do {
            let token = try JSONDecoder().decode(Token.self, from: data)
            self.token = token
            
            return token
        } catch {
            if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
                throw apiError
            }
            
            throw error
        }
    }
    
    func logOut() { token = nil }
}
