import IGListKit

class MessageSectionController: IGListSectionController {

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

    fileprivate(set) var viewModel: MessageViewModel?

    fileprivate let cellPrototype: MessageCell = {
        let cell = MessageCell(frame: .zero)
        cell.prepareForComputingHeight()
        return cell
    }()

    // MARK: Cell configuration

    fileprivate func configureCell(_ cell: MessageCell) {
        guard let viewModel = viewModel else { return }
        cell.label.text = viewModel.text
        if viewModel.isOutgoing {
            configureOutgoingCell(cell)
        } else {
            configureIncomingCell(cell)
        }
    }

    private func configureIncomingCell(_ cell: MessageCell) {
        cell.bubblePosition = .left
        cell.bubbleView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.92, alpha: 1)
        cell.label.textColor = .black
        cell.label.textAlignment = .left
    }

    private func configureOutgoingCell(_ cell: MessageCell) {
        cell.bubblePosition = .right
        cell.bubbleView.backgroundColor = UIColor(red: 0.01, green: 0.48, blue: 0.98, alpha: 1)
        cell.label.textColor = .white
        cell.label.textAlignment = .left
    }

}

extension MessageSectionController: IGListSectionType {

    func numberOfItems() -> Int {
        return 1
    }

    func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { fatalError() }
        let width = context.containerSize.width - inset.left - inset.right
        cellPrototype.prepareForReuse()
        configureCell(cellPrototype)
        let height = cellPrototype.computeHeight(forWidth: width)
        return CGSize(width: width, height: height)
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: MessageCell.self,
            for: self,
            at: index) as? MessageCell else { fatalError() }
        configureCell(cell)
        return cell
    }

    func didUpdate(to object: Any) {
        guard let viewModel = object as? MessageViewModel else { fatalError() }
        self.viewModel = viewModel
    }

    func didSelectItem(at index: Int) {}

}
