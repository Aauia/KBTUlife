import Foundation

struct User: Codable {
    let id: String
    let outlook: String
    let firstName: String
    let lastName: String
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case outlook
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
    }
}

struct LoginResponse: Codable {
    let message: String
    let user: User
    let sessionid: String
}

struct RegisterResponse: Codable {
    let message: String
    let user: User
}
