import Foundation

class DemoMessagesService {

    var fetchDelay: TimeInterval = 3
    var fetchError: Error?
    var sendDelay: TimeInterval = 2
    var sendError: Error?

    fileprivate var messages: [Message] = {
        let bundle = Bundle(for: DemoMessagesService.self)
        guard let path = bundle.path(forResource: "quotes", ofType: "json") else { fatalError() }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else { fatalError() }
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let jsonArray = jsonObject as? [[String]] else { fatalError() }
        return jsonArray.enumerated().map { (index, quote) in
            let uid = UUID().uuidString
            let text = quote[0]
            let author: String? = index % 2 == 0 ? quote[1] : nil
            return Message(uid: uid, text: text, author: author)
        }
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
            completion(.success(messages: self.messages))
        }
    }

    func sendMessage(_ text: String, completion: @escaping (MessagesServiceSendResult) -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + sendDelay) { [weak self] in
            guard let `self` = self else { return }
            if let error = self.sendError {
                completion(.failure(error: error))
                return
            }
            let message = Message(uid: UUID().uuidString, text: text, author: nil)
            completion(.success(message: message))
        }
    }

}
