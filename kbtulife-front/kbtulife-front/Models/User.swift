// Models.swift
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

// ✅ FIXED: Made message optional to handle error responses
struct LoginResponse: Codable {
    let message: String?  // Made optional
    let user: User?       // Made optional for error cases
    let sessionid: String?  // Made optional
    
    // For error responses
    let detail: String?
    let outlook: [String]?
    let password: [String]?
}

// ✅ FIXED: Made message optional to handle error responses
struct RegisterResponse: Codable {
    let message: String?  // Made optional
    let user: User?       // Made optional for error cases
    let sessionid: String?  // Made optional
    
    // For error responses
    let detail: String?
    let outlook: [String]?
    let password: [String]?
    let first_name: [String]?
    let last_name: [String]?
    let phone: [String]?
}

// ✅ NEW: Generic error response handler
struct ErrorResponse: Codable {
    let detail: String?
    
    // Catch-all for field errors
    private let container: [String: [String]]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Try to decode detail
        detail = try? container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "detail")!)
        
        // Decode all other keys as string arrays
        var errors: [String: [String]] = [:]
        for key in container.allKeys {
            if key.stringValue != "detail" {
                if let errorArray = try? container.decode([String].self, forKey: key) {
                    errors[key.stringValue] = errorArray
                }
            }
        }
        self.container = errors
    }
    
    // Get first error message
    var firstError: String {
        if let detail = detail {
            return detail
        }
        
        // Return first field error
        for (field, messages) in container {
            if let first = messages.first {
                return "\(field): \(first)"
            }
        }
        
        return "Unknown error"
    }
    
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
}
