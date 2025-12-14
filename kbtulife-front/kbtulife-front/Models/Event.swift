import Foundation

struct Event: Codable {
    let id: Int
    let name: String
    let description: String
    let location: String
    let date: String
    let price: String?
    let isFree: Bool
    let category: String
    let ticketsAvailable: Int
    let mediaUrls: [String]?
    let club: Int?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, location, date, price, category
        case isFree = "is_free"
        case ticketsAvailable = "tickets_available"
        case mediaUrls = "media_urls"
        case club
        case createdAt = "created_at"
    }
    
}
