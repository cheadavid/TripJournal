//
//  JournalService+Live.swift
//  TripJournal
//
//  Created by David Chea on 24/08/2025.
//

import SwiftUI

class LiveJournalService: JournalService {
    
    // MARK: - Publishers
    
    @Published var token: Token?
    
    // MARK: - Properties
    
    let baseURL: URL
    let session: URLSession
    
    // MARK: - Initialization
    
    init(baseURL: URL = URL(string: "http://localhost:8000")!, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: - Methods
    
    func makeRequest(
        path: String,
        method: String,
        body: Data? = nil,
        requiresAuth: Bool = true,
        contentType: String? = "application/json"
    ) throws -> URLRequest {
        if requiresAuth {
            guard token != nil else {
                struct AuthenticationError: LocalizedError {
                    var errorDescription: String? { "No authentication token available" }
                }
                
                throw AuthenticationError()
            }
        }
        
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if requiresAuth, let token = token {
            request.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        if let contentType = contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
}
