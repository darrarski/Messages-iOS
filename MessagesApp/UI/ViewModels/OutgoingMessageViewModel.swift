import IGListKit

class OutgoingMessageViewModel {

    init(text: String) {
        self.text = text
    }

    let uid: String = UUID().uuidString
    let text: String

}

extension OutgoingMessageViewModel: Equatable {

    static func == (lhs: OutgoingMessageViewModel, rhs: OutgoingMessageViewModel) -> Bool {
        return lhs.uid == rhs.uid
    }

}

extension OutgoingMessageViewModel: IGListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return uid as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? OutgoingMessageViewModel else { return false }
        return self == other
    }

}
