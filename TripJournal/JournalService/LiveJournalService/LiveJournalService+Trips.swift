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
        let request = try makeRequest(path: "trips", method: "GET")
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
    
    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        let request = try makeRequest(path: "trips/\(tripId)", method: "GET")
        let (data, _) = try await session.data(for: request)
        
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
    
    func createTrip(with tripCreate: TripCreate) async throws -> Trip {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(tripCreate)
        
        let request = try makeRequest(path: "trips", method: "POST", body: jsonData)
        let (data, _) = try await session.data(for: request)
        
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
    
    func updateTrip(withId tripId: Trip.ID, and tripUpdate: TripUpdate) async throws -> Trip {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(tripUpdate)
        
        let request = try makeRequest(path: "trips/\(tripId)", method: "PUT", body: jsonData)
        let (data, _) = try await session.data(for: request)
        
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
    
    func deleteTrip(withId tripId: Trip.ID) async throws {
        let request = try makeRequest(path: "trips/\(tripId)", method: "DELETE")
        let (data, response) = try await session.data(for: request)
        
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
