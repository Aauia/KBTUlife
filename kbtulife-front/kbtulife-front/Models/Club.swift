// Models/Club.swift
import Foundation

struct Club: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let instagramLink: String?
    let telegramLink: String?
    let manager: String  // User ID
    let members: [ClubMember]
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, manager, members
        case instagramLink = "instagram_link"
        case telegramLink = "telegram_link"
    }
}

struct ClubMember: Codable, Identifiable {
    let id: String
    let outlook: String
    let firstName: String
    let lastName: String
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, outlook
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrl = "avatar_url"
    }
}

struct Membership: Codable {
    let id: Int
    let status: String
    let userName: String
    let userSurname: String
    let userOutlook: String
    let clubName: String

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case userName = "user_name"
        case userSurname = "user_surname"
        case userOutlook = "user_outlook"
        case clubName = "club_name"
    }
}

