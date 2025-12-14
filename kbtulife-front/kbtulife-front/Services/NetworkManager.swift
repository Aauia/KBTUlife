// NetworkManager.swift
import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "http://localhost:8000/"
    
    // Session manager with cookie storage
    private lazy var session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.httpShouldSetCookies = true
        configuration.httpCookieAcceptPolicy = .always
        return Session(configuration: configuration)
    }()
    
    private var headers: HTTPHeaders {
        var h = HTTPHeaders()
        h["Content-Type"] = "application/json"
        
        // Add session ID if available
        if let sessionId = UserDefaults.standard.string(forKey: "sessionid") {
            h["Cookie"] = "sessionid=\(sessionId)"
        }
        return h
    }
    
    // MARK: - Authentication
    
    func login(outlook: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        let url = baseURL + "api/login/"
        let parameters: [String: Any] = [
            "outlook": outlook,
            "password": password
        ]
        
        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate() // Validate status code
            .responseData { response in
                switch response.result {
                case .success(let data):
                    // Try to decode as LoginResponse
                    if let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data),
                       let user = loginResponse.user,
                       let sessionid = loginResponse.sessionid {
                        
                        // Save session ID
                        UserDefaults.standard.set(sessionid, forKey: "sessionid")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        
                        // Save cookies
                        if let cookies = HTTPCookieStorage.shared.cookies {
                            let cookieData = try? NSKeyedArchiver.archivedData(withRootObject: cookies, requiringSecureCoding: false)
                            UserDefaults.standard.set(cookieData, forKey: "cookies")
                        }
                        
                        completion(user, nil)
                    } else {
                        // Try to decode error
                        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorResponse.firstError])
                            completion(nil, error)
                        } else {
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                            completion(nil, error)
                        }
                    }
                    
                case .failure(let error):
                    print("Login error: \(error)")
                    
                    // Try to extract error message from response data
                    if let data = response.data,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        let customError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorResponse.firstError])
                        completion(nil, customError)
                    } else {
                        completion(nil, error)
                    }
                }
            }
    }
    

    func register(outlook: String, firstName: String, lastName: String, phone: String?, password: String, completion: @escaping (User?, Error?) -> Void) {
        let url = baseURL + "api/register/"
        var parameters: [String: Any] = [
            "outlook": outlook,
            "first_name": firstName,
            "last_name": lastName,
            "password": password
        ]
        
        // Add phone if provided
        if let phone = phone, !phone.isEmpty {
            parameters["phone"] = phone
        }
        
        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    // Try to decode as RegisterResponse
                    if let registerResponse = try? JSONDecoder().decode(RegisterResponse.self, from: data),
                       let user = registerResponse.user {
                        
                        // Save session ID if available
                        if let sessionid = registerResponse.sessionid {
                            UserDefaults.standard.set(sessionid, forKey: "sessionid")
                        }
                        
                        // Mark as logged in
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        
                        // Save cookies
                        if let cookies = HTTPCookieStorage.shared.cookies {
                            let cookieData = try? NSKeyedArchiver.archivedData(withRootObject: cookies, requiringSecureCoding: false)
                            UserDefaults.standard.set(cookieData, forKey: "cookies")
                        }
                        
                        completion(user, nil)
                    } else {
                        // Try to decode error
                        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorResponse.firstError])
                            completion(nil, error)
                        } else {
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                            completion(nil, error)
                        }
                    }
                    
                case .failure(let error):
                    print("Registration error: \(error)")
                    
                    // Try to extract error message from response data
                    if let data = response.data,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        let customError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorResponse.firstError])
                        completion(nil, customError)
                    } else {
                        completion(nil, error)
                    }
                }
            }
    }
    
    func logout(completion: @escaping (Bool, Error?) -> Void) {
        let url = baseURL + "api/logout/"

        session.request(url, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    // Clear local session and cookies
                    UserDefaults.standard.removeObject(forKey: "sessionid")
                    UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                    UserDefaults.standard.removeObject(forKey: "cookies")
                    
                    HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }

                    completion(true, nil)
                case .failure(let error):
                    print("Logout failed:", error)
                    completion(false, error)
                }
            }
    }

    
    func fetchCurrentUser(completion: @escaping (User?, Error?) -> Void) {
        let url = baseURL + "api/me/"
        
        session.request(url, headers: headers)
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let user):
                    completion(user, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    // MARK: - Generic Methods
    
    func get<T: Decodable>(url: String, completion: @escaping (T?, Error?) -> Void) {
        let fullURL = baseURL + url
        // Было: AF.request → Не отправляет куки!
        // Стало: session.request → отправляет куки из HTTPCookieStorage
        session.request(fullURL, headers: headers).responseDecodable(of: T.self) { response in
            if let error = response.error {
                print("Network error: \(error)")
                if let data = response.data, let str = String(data: data, encoding: .utf8) {
                    print("Response body: \(str)")
                }
            }
            switch response.result {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func post<T: Decodable>(url: String, parameters: [String: Any], completion: @escaping (T?, Error?) -> Void) {
        let fullURL = baseURL + url
        // То же самое — используй session, а не AF
        session.request(fullURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    // MARK: - Events
    
    func fetchEvents(filters: [String: String] = [:], completion: @escaping ([Event]?, Error?) -> Void) {
        var url = "events/"
        if !filters.isEmpty {
            let query = filters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            url += "?\(query)"
        }
        get(url: url, completion: completion)
    }
    
    func fetchEventDetail(id: Int, completion: @escaping (Event?, Error?) -> Void) {
        let url = "events/\(id)/"
        get(url: url, completion: completion)
    }
    
    // MARK: - News
    
    func fetchNews(completion: @escaping ([News]?, Error?) -> Void) {
        get(url: "news/", completion: completion)
    }
    
    func fetchNewsDetail(id: Int, completion: @escaping (News?, Error?) -> Void) {
        let url = "news/\(id)/"
        get(url: url, completion: completion)
    }
    
    // MARK: - Tickets
    
    func fetchMyTickets(completion: @escaping ([Ticket]?, Error?) -> Void) {
        let url = "tickets/"
        AF.request(baseURL + url, headers: headers).responseDecodable(of: [Ticket].self) { response in
            switch response.result {
            case .success(let tickets):
                completion(tickets, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    func buyTicket(eventId: Int, completion: @escaping (Ticket?, Error?) -> Void) {
        let url = "tickets/"
        let parameters: [String: Any] = ["event_id": eventId]
        session.request(baseURL + url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: Ticket.self) { response in
                switch response.result {
                case .success(let ticket):
                    completion(ticket, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func markAsPending(ticketId: Int, completion: @escaping (String?, Error?) -> Void) {
        let url = "tickets/\(ticketId)/mark-as-pending/"
        session.request(baseURL + url, method: .post, headers: headers).responseString { response in
            switch response.result {
            case .success(let message):
                completion(message, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func validateQR(qrCode: String, completion: @escaping (Ticket?, Error?) -> Void) {
        let url = "tickets/validate-qr/"
        let params = ["qr_code": qrCode]
        session.request(baseURL + url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ValidateQRResponse.self) { response in
                switch response.result {
                case .success(let resp):
                    completion(resp.ticket, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    // MARK: - Clubs
    
    func fetchClubs(completion: @escaping ([Club]?, Error?) -> Void) {
        get(url: "clubs/", completion: completion)
    }

    func fetchClubDetail(_ id: Int, completion: @escaping (Club?, Error?) -> Void) {
        let url = "clubs/clubs/\(id)/"
        get(url: url, completion: completion)
    }
    
    func fetchClubMembers(clubId: Int, completion: @escaping ([ClubMember]?, Error?) -> Void) {
        let url = "clubs/\(clubId)/members/"
        get(url: url, completion: completion)
    }

    func fetchUserClubs(userId: String, completion: @escaping ([Club]?, Error?) -> Void) {
        let url = "users/\(userId)/clubs/"
        get(url: url, completion: completion)
    }

    func applyToClub(clubId: Int, completion: @escaping (Membership?, Error?) -> Void) {
        let url = "membership/apply/"
        let parameters: [String: Any] = ["club": clubId]
        post(url: url, parameters: parameters, completion: completion)
    }

    func createClub(name: String, description: String, instagramLink: String?, telegramLink: String?, completion: @escaping (Club?, Error?) -> Void) {
        let url = "clubs/create/"
        var parameters: [String: Any] = [
            "name": name,
            "description": description
        ]
        if let instagram = instagramLink, !instagram.isEmpty {
            parameters["instagram_link"] = instagram
        }
        if let telegram = telegramLink, !telegram.isEmpty {
            parameters["telegram_link"] = telegram
        }
        post(url: url, parameters: parameters, completion: completion)
    }
    
    // MARK: - Supporting Structs
    
    struct ValidateQRResponse: Codable {
        let status: String
        let ticket: Ticket?
        let message: String?
    }
}
