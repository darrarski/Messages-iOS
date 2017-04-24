import IGListKit

class MessageViewModel {

    init(message: Message, isOutgoing: Bool) {
        self.message = message
        self.isOutgoing = isOutgoing
    }

    let message: Message

    var text: String {
        return message.text
    }

    let isOutgoing: Bool

}

extension MessageViewModel: IGListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return text as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? MessageViewModel else { return false }
        return text == other.text
    }

}
