import Foundation

class DemoMessagesService {

    var fetchDelay: TimeInterval = 3
    var fetchError: Error?

    fileprivate let quotes: [String] = {
        let bundle = Bundle(for: DemoMessagesService.self)
        guard let path = bundle.path(forResource: "quotes", ofType: "json") else { fatalError() }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else { fatalError() }
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let jsonArray = jsonObject as? [[String]] else { fatalError() }
        let quotes = jsonArray.map { "\($0[0])\n(\($0[1]))" }
        return quotes
    }()

}

extension DemoMessagesService: MessagesService {

    func fetchMessages(completion: @escaping (MessagesServiceFetchResult) -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + fetchDelay) { [weak self] in
            guard let `self` = self else { return }
            if let error = self.fetchError {
                completion(.failure(error: error))
                return
            }
            let messages = self.quotes.map { Message(text: $0) }
            completion(.success(messages: messages))
        }
    }

}
