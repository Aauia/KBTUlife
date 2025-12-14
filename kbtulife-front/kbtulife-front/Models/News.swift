import Foundation

struct News: Codable, Identifiable {
    let id: Int
    let title: String
    let content: String
    let date: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, date
        case imageUrl = "image_url"
    }
}
