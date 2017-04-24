import IGListKit

class MessageViewModel {

    init(message: Message) {
        self.message = message
    }

    let message: Message

    var text: String {
        return message.text
    }

    var isOutgoing: Bool {
        return message.author == nil
    }

}

extension MessageViewModel: IGListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return message.uid as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? MessageViewModel else { return false }
        return message.uid == other.message.uid
    }

}
