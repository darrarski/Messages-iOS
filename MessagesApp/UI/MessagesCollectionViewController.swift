import UIKit
import IGListKit

class MessagesCollectionViewController: UICollectionViewController {

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    var listCollectionView: IGListCollectionView! {
        return collectionView as? IGListCollectionView
    }

    override func loadView() {
        super.loadView()
        collectionView = Factory.listCollectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupList()
    }

    // MARK: List

    private let listUpdater = IGListAdapterUpdater()

    private(set) lazy var listAdapter: IGListAdapter = {
        return IGListAdapter(updater: self.listUpdater, viewController: self, workingRangeSize: 0)
    }()

    private func setupList() {
        listAdapter.collectionView = listCollectionView
        listAdapter.dataSource = self
    }

    // MARK: Data

    var messages = [String]() {
        didSet { listAdapter.performUpdates(animated: true) }
    }

}

extension MessagesCollectionViewController: IGListAdapterDataSource {

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return messages as [IGListDiffable]
    }

    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        switch object {
        case is String:
            return MessageSectionController()
        default:
            fatalError()
        }
    }

    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }

}

extension MessagesCollectionViewController {

    struct Factory {

        static var collectionViewLayout: UICollectionViewFlowLayout {
            return UICollectionViewFlowLayout()
        }

        static var listCollectionView: IGListCollectionView {
            let layout = Factory.collectionViewLayout
            let view = IGListCollectionView(frame: .zero, collectionViewLayout: layout)
            view.backgroundColor = .white
            view.keyboardDismissMode = .interactive
            return view
        }

    }

}
