import Foundation
struct Review: Codable, Identifiable {
    let id: Int
    let eventId: Int
    let userId: String
    let rating: Int
    let comment: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, rating, comment
        case eventId = "event_id"
        case userId = "user_id"
        case createdAt = "created_at"
    }
}
