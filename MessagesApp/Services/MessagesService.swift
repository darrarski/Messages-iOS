import Foundation

protocol MessagesService {
    func fetchMessages(completion: @escaping (MessagesServiceFetchResult) -> Void)
}

enum MessagesServiceFetchResult {
    case success(messages: [Message])
    case failure(error: Error)
}
