import IGListKit

class MessageSectionController: IGListSectionController {

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }

    fileprivate(set) var viewModel: MessageViewModel?

    // MARK: Cell size

    fileprivate func cellWidth() -> CGFloat {
        guard let context = collectionContext else { fatalError() }
        return context.containerSize.width - inset.left - inset.right
    }

    fileprivate func cellHeight(forWidth width: CGFloat) -> CGFloat {
        cellPrototype.prepareForReuse()
        configureCell(cellPrototype)
        cellPrototype.bounds = {
            var bounds = cellPrototype.bounds
            bounds.size.width = width
            return bounds
        }()
        cellPrototype.setNeedsLayout()
        cellPrototype.layoutIfNeeded()
        let targetSize = CGSize(width: width, height: 0)
        let fittingSize = cellPrototype.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: UILayoutPriorityDefaultHigh,
            verticalFittingPriority: UILayoutPriorityFittingSizeLevel
        )
        return fittingSize.height
    }

    private let cellPrototype: MessageCell = {
        let cell = MessageCell(frame: .zero)
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }()

    // MARK: Cell configuration

    fileprivate func configureCell(_ cell: MessageCell) {
        cell.label.text = viewModel?.text
        guard let index = collectionContext?.section(for: self) else { fatalError() }
        if index % 2 == 0 {
            configureIncomingCell(cell)
        } else {
            configureOutgoingCell(cell)
        }
    }

    private func configureIncomingCell(_ cell: MessageCell) {
        cell.bubblePosition = .left
        cell.bubbleView.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.92, alpha:1)
        cell.label.textColor = .black
        cell.label.textAlignment = .left
    }

    private func configureOutgoingCell(_ cell: MessageCell) {
        cell.bubblePosition = .right
        cell.bubbleView.backgroundColor = UIColor(red:0.01, green:0.48, blue:0.98, alpha:1)
        cell.label.textColor = .white
        cell.label.textAlignment = .left
    }

}

extension MessageSectionController: IGListSectionType {

    func numberOfItems() -> Int {
        return 1
    }

    func sizeForItem(at index: Int) -> CGSize {
        let width = cellWidth()
        let height = cellHeight(forWidth: width)
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
