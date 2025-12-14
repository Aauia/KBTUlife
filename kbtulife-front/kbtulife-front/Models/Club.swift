struct Club: Codable {
    let id: Int
    let name: String
    let description: String
    let instagramLink: String
    let telegramLink: String
    let mediaUrls: [String]?
}
