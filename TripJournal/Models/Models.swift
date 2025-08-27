import Foundation
import MapKit

/// Represents  a token that is returns when the user authenticates.
struct Token: Codable {
    let accessToken: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

/// Represents a trip.
struct Trip: Codable, Identifiable, Sendable, Hashable {
    var id: Int
    var name: String
    var startDate: Date
    var endDate: Date
    var events: [Event]
    
    enum CodingKeys: String, CodingKey {
        case id, name, events
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

/// Represents an event in a trip.
struct Event: Codable, Identifiable, Sendable, Hashable {
    var id: Int
    var name: String
    var note: String?
    var date: Date
    var location: Location?
    var medias: [Media]
    var transitionFromPrevious: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, note, date, location, medias
        case transitionFromPrevious = "transition_from_previous"
    }
}

/// Represents a location.
struct Location: Codable, Sendable, Hashable {
    var latitude: Double
    var longitude: Double
    var address: String?
    
    var coordinate: CLLocationCoordinate2D {
        return .init(latitude: latitude, longitude: longitude)
    }
}

/// Represents a media with a URL.
struct Media: Codable, Identifiable, Sendable, Hashable {
    var id: Int
    var url: URL?
}

struct ApiError: Codable, LocalizedError {
    let detail: String
    
    var errorDescription: String? { detail }
}
