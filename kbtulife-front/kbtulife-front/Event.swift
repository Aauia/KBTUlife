import Foundation

struct Event: Codable {
    let id: Int
    let name: String
    let description: String
    let date: String  // ISO format
    let price: String
    let isFree: Bool
    let ticketsAvailable: Int
    let mediaUrls: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, date, price, isFree = "is_free", ticketsAvailable = "tickets_available", mediaUrls = "media_urls"
    }
}
