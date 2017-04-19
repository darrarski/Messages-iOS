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

    let collectionView: UICollectionView = Factory.collectionView

    private func loadSubviews() {
        addSubview(collectionView)
    }

    // MARK: Layout

    private func setupLayout() {
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

}

private extension MessagesView {

    struct Factory {

        static var collectionView: UICollectionView {
            let layout = UICollectionViewFlowLayout()
            let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
            view.backgroundColor = .clear
            return view
        }

    }

}
