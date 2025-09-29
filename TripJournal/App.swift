import SwiftUI

@main
struct TripJournalApp: App {
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            RootView(service: LiveJournalService())
        }
    }
}
