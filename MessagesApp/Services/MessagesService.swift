import Foundation

protocol MessagesService {
    func fetchMessages(page: Int, perPage: Int, completion: @escaping (MessagesServiceFetchResult) -> Void)
    func sendMessage(_ text: String, completion: @escaping (MessagesServiceSendResult) -> Void)
}

enum MessagesServiceFetchResult {
    case success(messages: [Message])
    case failure(error: Error)
}

enum MessagesServiceSendResult {
    case success(message: Message)
    case failure(error: Error)
}
