import Foundation

struct NewsItem: Codable {
    let id: Int
    let title: String
    let content: String
    let imageUrl: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, createdAt = "created_at"
        case imageUrl = "image_url" 
    }
}
