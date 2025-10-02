//
//  LiveJournalService+Events.swift
//  TripJournal
//
//  Created by David Chea on 02/10/2025.
//

import SwiftUI

extension LiveJournalService {
    
    // MARK: - Methods
    
    func createEvent(with eventCreate: EventCreate) async throws -> Event {
        guard let token = token else {
            struct AuthenticationError: LocalizedError {
                var errorDescription: String? { "No authentication token available" }
            }
            
            throw AuthenticationError()
        }
        
        let url = baseURL.appendingPathComponent("events")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(eventCreate)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let (data, _) = try await session.data(for: urlRequest)
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(Event.self, from: data)
        } catch {
            if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
                throw apiError
            }
            
            throw error
        }
    }
    
    func updateEvent(withId eventId: Event.ID, and eventUpdate: EventUpdate) async throws -> Event {
        guard let token = token else {
            struct AuthenticationError: LocalizedError {
                var errorDescription: String? { "No authentication token available" }
            }
            
            throw AuthenticationError()
        }
        
        let url = baseURL.appendingPathComponent("events").appendingPathComponent("\(eventId)")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(eventUpdate)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let (data, _) = try await session.data(for: urlRequest)
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(Event.self, from: data)
        } catch {
            if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
                throw apiError
            }
            
            throw error
        }
    }
    
    func deleteEvent(withId eventId: Event.ID) async throws {
        guard let token = token else {
            struct AuthenticationError: LocalizedError {
                var errorDescription: String? { "No authentication token available" }
            }
            
            throw AuthenticationError()
        }
        
        let url = baseURL.appendingPathComponent("events").appendingPathComponent("\(eventId)")
        
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
