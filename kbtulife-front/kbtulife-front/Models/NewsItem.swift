import UIKit
import SDWebImage

struct NewsItem: Codable {
    let id: Int
    let title: String
    let titleKk: String?
    let titleRu: String?
    let titleEn: String?
    let content: String
    let contentKk: String?
    let contentRu: String?
    let contentEn: String?
    let mediaUrl: String?
    let createdAt: String
    
    let media_urls: [String]?
    
    var imageUrl: String? {
        if let urls = media_urls, let first = urls.first, !first.isEmpty {
            return first
        }
        return mediaUrl
    }
    
    var category: String = "General"
    var readTime: String = "3 min"
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = formatter.date(from: createdAt) {
            formatter.dateStyle = .medium
            formatter.timeZone = TimeZone.current
            return formatter.string(from: date)
        }
        return "Today"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleKk = "title_kk"
        case titleRu = "title_ru"
        case titleEn = "title_en"
        case content
        case contentKk = "content_kk"
        case contentRu = "content_ru"
        case contentEn = "content_en"
        case mediaUrl = "media_url"
        case createdAt = "created_at"
        case media_urls = "media_urls"  
    }
}
