import Foundation

struct Event: Codable {
    let id: Int
    let name: String
    let description: String
    let location: String
    let date: String
    let organizer: String?
    let price: String
    let isFree: Bool
    let category: String  // ярмарки, семинары и т.д.
    let ticketsAvailable: Int
    let mediaUrls: [String]?
}
