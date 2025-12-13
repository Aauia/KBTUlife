import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "http://0.0.0.0:8000/api/"  // Твой URL
    private let session: Session
    
    private init() {
        session = Session()
    }
    
    // GET Events
    func fetchEvents(completion: @escaping ([Event]?, Error?) -> Void) {
        let url = baseURL + "events/"
        session.request(url).responseDecodable(of: [Event].self) { response in
            switch response.result {
            case .success(let events): completion(events, nil)
            case .failure(let error): completion(nil, error)
            }
        }
    }
    
    // POST Buy Ticket
    func buyTicket(eventId: Int, completion: @escaping (Ticket?, Error?) -> Void) {
        let url = baseURL + "tickets/"
        let params: [String: Any] = ["event_id": eventId]
        session.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseDecodable(of: Ticket.self) { response in
            switch response.result {
            case .success(let ticket): completion(ticket, nil)
            case .failure(let error): completion(nil, error)
            }
        }
    }
    
    // PATCH Mark as Pending
    func markAsPending(ticketId: Int, completion: @escaping (String?, Error?) -> Void) {
        let url = baseURL + "tickets/\(ticketId)/mark-as-pending/"
        session.request(url, method: .post).responseString { response in
            switch response.result {
            case .success(let message): completion(message, nil)
            case .failure(let error): completion(nil, error)
            }
        }
    }
    
    // GET My Tickets
    func fetchMyTickets(completion: @escaping ([Ticket]?, Error?) -> Void) {
        let url = baseURL + "tickets/"
        session.request(url).responseDecodable(of: [Ticket].self) { response in
            switch response.result {
            case .success(let tickets): completion(tickets, nil)
            case .failure(let error): completion(nil, error)
            }
        }
    }
    
    // POST Validate QR (для менеджера)
    func validateQR(qrCode: String, completion: @escaping (Ticket?, Error?) -> Void) {
        let url = baseURL + "tickets/validate-qr/"
        let params: [String: String] = ["qr_code": qrCode]
        session.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseDecodable(of: QRValidationResponse.self) { response in
            switch response.result {
            case .success(let res): completion(res.ticket, nil)
            case .failure(let error): completion(nil, error)
            }
        }
    }
    
    // Struct для ответа validate
    struct QRValidationResponse: Codable {
        let status: String
        let ticket: Ticket?
    }
}

