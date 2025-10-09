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
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(eventCreate)
        
        let request = try makeRequest(path: "events", method: "POST", body: jsonData)
        let (data, _) = try await session.data(for: request)
        
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
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(eventUpdate)
        
        let request = try makeRequest(path: "events/\(eventId)", method: "PUT", body: jsonData)
        let (data, _) = try await session.data(for: request)
        
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
        let request = try makeRequest(path: "events/\(eventId)", method: "DELETE")
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
