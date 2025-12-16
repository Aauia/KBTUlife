import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "http://localhost:8000/"
    
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
        
        if let csrfToken = HTTPCookieStorage.shared.cookies?
            .compactMap({ $0.name == "csrftoken" ? $0.value : nil })
            .first {
            h["X-CSRFToken"] = csrfToken
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
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data),
                       let user = loginResponse.user {
                        
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        completion(user, nil)
                        
                    } else if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorResponse.firstError])
                        completion(nil, error)
                    } else {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    print("Login error: \(error)")
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
        
        if let phone = phone, !phone.isEmpty {
            parameters["phone"] = phone
        }
        
        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let registerResponse = try? JSONDecoder().decode(RegisterResponse.self, from: data),
                       let user = registerResponse.user {
                        
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        completion(user, nil)
                        
                    } else if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorResponse.firstError])
                        completion(nil, error)
                    } else {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                        completion(nil, error)
                    }
                    
                case .failure(let error):
                    print("Registration error: \(error)")
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
                    
                    UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
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
        session.request(fullURL, headers: headers)
            .responseDecodable(of: T.self) { response in
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
        get(url: "events/\(id)/", completion: completion)
    }
    
    // MARK: - News
    func fetchNews(completion: @escaping ([NewsItem]?, Error?) -> Void) {
        get(url: "news/", completion: completion)
    }
    
    func fetchNewsDetail(id: Int, completion: @escaping (NewsItem?, Error?) -> Void) {
        get(url: "news/\(id)/", completion: completion)
    }
    
    // MARK: - Tickets
    func fetchMyTickets(completion: @escaping ([Ticket]?, Error?) -> Void) {
        let url = "tickets/"
        session.request(baseURL + url, headers: headers)
            .responseDecodable(of: [Ticket].self) { response in
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
        
        session.request(baseURL + url,
                        method: .post,
                        parameters: parameters,
                        encoding: JSONEncoding.default,
                        headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Ticket.self) { response in

                debugPrint("Request URL: \(response.request?.url?.absoluteString ?? "nil")")
                debugPrint("Request Body: \(String(data: response.request?.httpBody ?? Data(), encoding: .utf8) ?? "nil")")
                debugPrint("Status Code: \(response.response?.statusCode ?? -1)")
                
                if let data = response.data,
                   let errorString = String(data: data, encoding: .utf8) {
                    print("Сервер вернул: \(errorString)")
                }
                
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
        session.request(baseURL + url, method: .post, headers: headers)
            .responseString { response in
                switch response.result {
                case .success(let message):
                    completion(message, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func validateQR(qrCode: String, completion: @escaping (Ticket?, Error?) -> Void) {
        let params = ["qr_code": qrCode]
        session.request(baseURL + "tickets/validate-qr/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
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
        get(url: "clubs/clubs/\(id)/", completion: completion)
    }
    
    func fetchClubMembers(clubId: Int, completion: @escaping ([ClubMember]?, Error?) -> Void) {
        get(url: "clubs/\(clubId)/members/", completion: completion)
    }
    
    func fetchUserClubs(userId: String, completion: @escaping ([Club]?, Error?) -> Void) {
        get(url: "users/\(userId)/clubs/", completion: completion)
    }
    
    func applyToClub(clubId: Int, completion: @escaping (Membership?, Error?) -> Void) {
        let parameters: [String: Any] = ["club": clubId]
        post(url: "clubs/membership/apply/", parameters: parameters, completion: completion)
    }
    
    func createClub(name: String, description: String, instagramLink: String?, telegramLink: String?, completion: @escaping (Club?, Error?) -> Void) {
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
        post(url: "clubs/create/", parameters: parameters, completion: completion)
    }
    
    // MARK: - Supporting Structs
    struct ValidateQRResponse: Codable {
        let status: String
        let ticket: Ticket?
        let message: String?
    }
}
