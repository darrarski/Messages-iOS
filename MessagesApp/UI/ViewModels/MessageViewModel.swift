import IGListKit

class MessageViewModel {

    init(text: String) {
        self.text = text
    }

    let text: String

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
