import IGListKit

class OutgoingMessageSectionController: IGListSectionController {

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

    fileprivate(set) var viewModel: OutgoingMessageViewModel?

    fileprivate let cellPrototype: MessageCell = {
        let cell = MessageCell(frame: .zero)
        cell.prepareForComputingHeight()
        return cell
    }()

    // MARK: Cell configuration

    fileprivate func configureCell(_ cell: MessageCell) {
        cell.label.text = viewModel?.text
        cell.bubblePosition = .right
        cell.bubbleView.backgroundColor = UIColor(red:0.01, green:0.48, blue:0.98, alpha:0.6)
        cell.label.textColor = .white
        cell.label.textAlignment = .left
        cell.activityIndicator.startAnimating()
    }

}

extension OutgoingMessageSectionController: IGListSectionType {

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
        guard let viewModel = object as? OutgoingMessageViewModel else { fatalError() }
        self.viewModel = viewModel
    }

    func didSelectItem(at index: Int) {}

}
