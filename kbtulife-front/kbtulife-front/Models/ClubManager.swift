
import Foundation

struct ClubManager: Codable {
    let id: Int
    let club: Int
    let user: String
    let userOutlook: String
    let userName: String
    let role: String
    
    enum CodingKeys: String, CodingKey {
        case id, club, user, role
        case userOutlook = "user_outlook"
        case userName = "user_name"
    }
}

struct MembershipActionRequest: Codable {
    let status: String
}


struct ClubManagerStatusResponse: Codable {
    let isManager: Bool
    let managedClubs: [ManagedClub]
    
    enum CodingKeys: String, CodingKey {
        case isManager = "is_manager"
        case managedClubs = "managed_clubs"
    }
}

struct ManagedClub: Codable {
    let id: Int
    let name: String
    let description: String
}
