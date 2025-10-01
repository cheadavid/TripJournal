//
//  JournalService+Live.swift
//  TripJournal
//
//  Created by David Chea on 24/08/2025.
//

import SwiftUI
import Combine

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
    
    // MARK: - Trip Management (Empty implementations for testing)
    
    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        // TODO: Implement
        fatalError("Not implemented yet")
    }
    
    func deleteTrip(withId tripId: Trip.ID) async throws {
        // TODO: Implement
        fatalError("Not implemented yet")
    }
    
    // MARK: - Event Management (Empty implementations for testing)
    
    func createEvent(with request: EventCreate) async throws -> Event {
        // TODO: Implement
        fatalError("Not implemented yet")
    }
    
    func updateEvent(withId eventId: Event.ID, and request: EventUpdate) async throws -> Event {
        // TODO: Implement
        fatalError("Not implemented yet")
    }
    
    func deleteEvent(withId eventId: Event.ID) async throws {
        // TODO: Implement
        fatalError("Not implemented yet")
    }
    
    // MARK: - Media Management (Empty implementations for testing)
    
    func createMedia(with request: MediaCreate) async throws -> Media {
        // TODO: Implement
        fatalError("Not implemented yet")
    }
    
    func deleteMedia(withId mediaId: Media.ID) async throws {
        // TODO: Implement
        fatalError("Not implemented yet")
    }
}
