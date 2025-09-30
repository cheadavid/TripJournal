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
        let url = baseURL.appendingPathComponent("trips")
        
        guard let token = token else {
            struct AuthenticationError: LocalizedError {
                var errorDescription: String? { "No authentication token available" }
            }
            
            throw AuthenticationError()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, _) = try await session.data(for: request)
        
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
    
    func createTrip(with request: TripCreate) async throws -> Trip {
        let url = baseURL.appendingPathComponent("trips")
        let jsonData = try JSONEncoder().encode(request)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, _) = try await session.data(for: request)
        
        do {
            return try JSONDecoder().decode(Trip.self, from: data)
        } catch {
            if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
                throw apiError
            }
            
            throw error
        }
    }
}
