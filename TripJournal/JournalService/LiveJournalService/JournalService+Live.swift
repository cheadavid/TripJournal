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
}
