import UIKit
import SnapKit

class MessagesCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
        setupLayout()
        cleanUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cleanUp()
    }

    private func cleanUp() {
        bubblePosition = nil
        bubbleView.backgroundColor = .clear
        label.textColor = .darkGray
        label.textAlignment = .center
    }

    // MARK: Subviews

    let bubbleView = Factory.bubbleView
    let label = Factory.label

    private func loadSubviews() {
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(label)
    }

    // MARK: Layout

    enum BubblePosition {
        case left
        case right
    }

    var bubblePosition: BubblePosition? {
        didSet {
            switch bubblePosition {
            case .some(.left):
                bubbleViewRightConstraint.deactivate()
                bubbleViewLeftConstraint.activate()
            case .some(.right):
                bubbleViewLeftConstraint.deactivate()
                bubbleViewRightConstraint.activate()
            case .none:
                bubbleViewLeftConstraint.deactivate()
                bubbleViewRightConstraint.deactivate()
            }
        }
    }

    private func setupLayout() {
        bubbleView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
            $0.width.greaterThanOrEqualTo(16)
            $0.centerX.equalToSuperview().priority(.low)
        }
        bubbleView.snp.makeConstraints {
            bubbleViewLeftConstraint = $0.left.equalToSuperview().constraint
        }
        bubbleViewLeftConstraint.deactivate()
        bubbleView.snp.makeConstraints {
            bubbleViewRightConstraint = $0.right.equalToSuperview().constraint
        }
        bubbleViewRightConstraint.deactivate()
        label.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
    }

    private var bubbleViewLeftConstraint: Constraint!
    private var bubbleViewRightConstraint: Constraint!

}

private extension MessagesCell {

    struct Factory {

        static var bubbleView: UIView {
            let view = UIView(frame: .zero)
            view.backgroundColor = .lightGray
            view.layer.cornerRadius = 16
            return view
        }

        static var label: UILabel {
            let label = UILabel(frame: .zero)
            label.numberOfLines = 0
            return label
        }

    }

}
