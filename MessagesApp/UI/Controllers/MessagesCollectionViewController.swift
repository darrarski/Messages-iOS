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

    let refreshControl = UIRefreshControl()

    override func loadView() {
        super.loadView()
        collectionView = Factory.listCollectionView
        collectionView?.refreshControl = refreshControl
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupList()
    }

    // MARK: ViewModels

    private(set) var messages = [MessageViewModel]()
    private(set) var outgoingMessages = [OutgoingMessageViewModel]()

    func updateMessages(_ newMessages: [MessageViewModel], completion: @escaping () -> Void = {}) {
        messages = newMessages.uniqueElements
        updateList(animated: false, completion: completion)
    }

    func appendMessages(_ newMessages: [MessageViewModel], completion: @escaping () -> Void = {}) {
        var messages = self.messages
        messages.append(contentsOf: newMessages)
        self.messages = messages.uniqueElements
        updateList(animated: false, completion: completion)
    }

    func insertMessage(_ message: MessageViewModel, completion: @escaping () -> Void = {}) {
        var messages = self.messages
        messages.insert(message, at: 0)
        self.messages = messages.uniqueElements
        updateList(animated: false, completion: completion)
    }

    func insertOutgoingMessage(_ message: OutgoingMessageViewModel) {
        var outgoingMessages = self.outgoingMessages
        outgoingMessages.insert(message, at: 0)
        self.outgoingMessages = outgoingMessages.uniqueElements
        updateList(animated: true)
    }

    func removeOutgoingMessage(_ message: OutgoingMessageViewModel) {
        guard let index = outgoingMessages.index(where: { $0 == message }) else { return }
        outgoingMessages.remove(at: index)
        updateList(animated: true)
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

    private func updateList(animated: Bool, completion: @escaping () -> Void = {}) {
        let reversedContentOffset = listCollectionView.reversedContentOffset
        listAdapter.performUpdates(animated: animated) { [weak self] _ in
            self?.listCollectionView.setReversedContentOffset(reversedContentOffset, animated: animated)
            completion()
        }
    }

}

extension MessagesCollectionViewController: IGListAdapterDataSource {

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        var objects = [IGListDiffable]()
        objects.append(contentsOf: outgoingMessages as [IGListDiffable])
        objects.append(contentsOf: messages as [IGListDiffable])
        return objects
    }

    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        switch object {
        case is MessageViewModel:
            return MessageSectionController()
        case is OutgoingMessageViewModel:
            return OutgoingMessageSectionController()
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
            return MessagesCollectionViewLayout()
        }

        static var listCollectionView: IGListCollectionView {
            let layout = Factory.collectionViewLayout
            let view = IGListCollectionView(frame: .zero, collectionViewLayout: layout)
            view.backgroundColor = .white
            view.keyboardDismissMode = .interactive
            view.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            return view
        }

    }

}
