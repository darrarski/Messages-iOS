import IGListKit

class OutgoingMessageViewModel {

    init(text: String) {
        self.text = text
    }

    let uid = UUID()
    let text: String

}

extension OutgoingMessageViewModel: IGListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return uid as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let other = object as? OutgoingMessageViewModel else { return false }
        return uid == other.uid
    }

}
