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
        let jsonData = try JSONEncoder().encode(mediaCreate)
        let request = try makeRequest(path: "media", method: "POST", body: jsonData)
        let (data, _) = try await session.data(for: request)
        
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
        let request = try makeRequest(path: "media/\(mediaId)", method: "DELETE")
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
