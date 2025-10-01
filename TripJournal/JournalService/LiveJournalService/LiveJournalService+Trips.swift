//
//  LiveJournalService+Trips.swift
//  TripJournal
//
//  Created by David Chea on 27/08/2025.
//

import SwiftUI

extension LiveJournalService {
    
    // MARK: - Methods
    
    func getTrips() async throws -> [Trip] {
        guard let token = token else {
            struct AuthenticationError: LocalizedError {
                var errorDescription: String? { "No authentication token available" }
            }
            
            throw AuthenticationError()
        }
        
        let url = baseURL.appendingPathComponent("trips")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, _) = try await session.data(for: urlRequest)
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode([Trip].self, from: data)
        } catch {
            if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
                throw apiError
            }
            
            throw error
        }
    }
    
    func createTrip(with tripCreate: TripCreate) async throws -> Trip {
        guard let token = token else {
            struct AuthenticationError: LocalizedError {
                var errorDescription: String? { "No authentication token available" }
            }
            
            throw AuthenticationError()
        }
        
        let url = baseURL.appendingPathComponent("trips")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(tripCreate)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let (data, _) = try await session.data(for: urlRequest)
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(Trip.self, from: data)
        } catch {
            if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
                throw apiError
            }
            
            throw error
        }
    }
    
    func updateTrip(withId tripId: Trip.ID, and request: TripUpdate) async throws -> Trip {
        // TODO: Implement
        fatalError("Not implemented yet")
    }
}
