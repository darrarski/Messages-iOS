import IGListKit

class MessageViewModel {

    init(message: Message) {
        self.message = message
    }

    let message: Message

    var text: String {
        return message.text
    }

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
