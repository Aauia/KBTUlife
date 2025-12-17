// ClubManagerModels.swift
import Foundation

// MARK: - Club Manager
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

// MARK: - Membership
//struct MembershipStatusUpdate: Encodable {
  //  let status: String
//}

// MARK: - Membership Action Request
struct MembershipActionRequest: Codable {
    let status: String // "accepted" or "declined"
}

// MARK: - Club Manager Status Response
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
