import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "http://0.0.0.0:8000/api/"
    
    private var headers: HTTPHeaders {
        var h = HTTPHeaders()
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            h["Authorization"] = "Token \(token)"
        }
        return h
    }
    
    // Generic GET method
    func get<T: Decodable>(url: String, completion: @escaping (T?, Error?) -> Void) {
        let fullURL = baseURL + url
        AF.request(fullURL, headers: headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    // POST method (для покупки билета, login и т.д.)
    func post<T: Decodable>(url: String, parameters: [String: Any], completion: @escaping (T?, Error?) -> Void) {
        let fullURL = baseURL + url
        AF.request(fullURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func markAsPending(ticketId: Int, completion: @escaping (String?, Error?) -> Void) {
        let url = "tickets/\(ticketId)/mark-as-pending/"
        AF.request(baseURL + url, method: .post, headers: headers).responseString { response in
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
        AF.request(baseURL + url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ValidateQRResponse.self) { response in
                switch response.result {
                case .success(let resp):
                    completion(resp.ticket, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    struct ValidateQRResponse: Codable {
        let status: String
        let ticket: Ticket?
        let message: String?
    }
    // Покупка билета на событие
    func buyTicket(eventId: Int, completion: @escaping (Ticket?, Error?) -> Void) {
        let url = "tickets/"
        let parameters: [String: Any] = ["event_id": eventId]
        
        AF.request(baseURL + url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: Ticket.self) { response in
                switch response.result {
                case .success(let ticket):
                    completion(ticket, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    // Загрузка моих билетов
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
}
