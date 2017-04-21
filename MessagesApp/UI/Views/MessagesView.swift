import UIKit
import SnapKit

class MessagesView: UIView {

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        loadSubviews()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Subviews

    let collectionViewContainer = UIView(frame: .zero)

    private func loadSubviews() {
        addSubview(collectionViewContainer)
    }

    // MARK: Layout

    private func setupLayout() {
        collectionViewContainer.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

}
