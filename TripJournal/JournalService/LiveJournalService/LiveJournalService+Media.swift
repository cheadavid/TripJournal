//
//  LiveJournalService+Media.swift
//  TripJournal
//
//  Created by David Chea on 02/10/2025.
//

import SwiftUI

extension LiveJournalService {
    
    // MARK: - Methods
    
    func createMedia(with mediaCreate: MediaCreate) async throws -> Media {
        guard let token = token else {
            struct AuthenticationError: LocalizedError {
                var errorDescription: String? { "No authentication token available" }
            }
            
            throw AuthenticationError()
        }
        
        let url = baseURL.appendingPathComponent("media")
        let jsonData = try JSONEncoder().encode(mediaCreate)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let (data, _) = try await session.data(for: urlRequest)
        
        do {
            return try JSONDecoder().decode(Media.self, from: data)
        } catch {
            if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
                throw apiError
            }
            
            throw error
        }
    }
    
    func deleteMedia(withId mediaId: Media.ID) async throws {
        guard let token = token else {
            struct AuthenticationError: LocalizedError {
                var errorDescription: String? { "No authentication token available" }
            }
            
            throw AuthenticationError()
        }
        
        let url = baseURL.appendingPathComponent("media").appendingPathComponent("\(mediaId)")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 204 || httpResponse.statusCode == 200 {
                return
            }
        }
        
        if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
            throw apiError
        }
    }
}
