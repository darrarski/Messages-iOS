import UIKit

class MessagesViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View

    var messagesView: MessagesView! {
        return view as? MessagesView
    }

    override func loadView() {
        view = MessagesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        embedCollectionViewController()
        setupCollectionView()
        messages = loadMessages()
    }

    // MARK: Messages

    var messages = [String]()

    private func loadMessages() -> [String] {
        let bundle = Bundle(for: MessagesViewController.self)
        guard let path = bundle.path(forResource: "quotes", ofType: "json") else { fatalError() }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else { fatalError() }
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let jsonArray = jsonObject as? [[String]] else { fatalError() }
        let quotes = jsonArray.map { "\($0[0])\n(\($0[1]))" }
        var messages = [String]()
        (1...10).enumerated().forEach { _ in messages += quotes }
        return messages
    }

    // MARK: CollectionView

    let collectionViewController = MessagesCollectionViewController()

    private func embedCollectionViewController() {
        addChildViewController(collectionViewController)
        messagesView.collectionViewContainer.addSubview(collectionViewController.view)
        collectionViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        collectionViewController.didMove(toParentViewController: self)
    }

    private func setupCollectionView() {
        collectionViewController.collectionView?.register(MessagesCell.self, forCellWithReuseIdentifier: "cell")
        collectionViewController.collectionView?.dataSource = self
        collectionViewController.collectionView?.delegate = self
        collectionViewController.collectionView?.keyboardDismissMode = .interactive
    }

    fileprivate func configureIncomingMessage(cell: MessagesCell) {
        cell.bubblePosition = .left
        cell.bubbleView.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.92, alpha:1)
        cell.label.textColor = .black
        cell.label.textAlignment = .left
    }

    fileprivate func configureOutgoingMessage(cell: MessagesCell) {
        cell.bubblePosition = .right
        cell.bubbleView.backgroundColor = UIColor(red:0.01, green:0.48, blue:0.98, alpha:1)
        cell.label.textColor = .white
        cell.label.textAlignment = .left
    }

    fileprivate func configureMessage(cell: MessagesCell, at indexPath: IndexPath) {
        cell.label.text = messages[indexPath.row]
    }

    private let messagesCellPrototype: MessagesCell = {
        let cell = MessagesCell(frame: .zero)
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }()

    fileprivate func heightForMessageCell(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        messagesCellPrototype.prepareForReuse()
        configureMessage(cell: messagesCellPrototype, at: indexPath)
        messagesCellPrototype.bounds = {
            var bounds = messagesCellPrototype.bounds
            bounds.size.width = width
            return bounds
        }()
        messagesCellPrototype.setNeedsLayout()
        messagesCellPrototype.layoutIfNeeded()
        let targetSize = CGSize(width: width, height: 0)
        let fittingSize = messagesCellPrototype.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: UILayoutPriorityDefaultHigh,
            verticalFittingPriority: UILayoutPriorityFittingSizeLevel
        )
        return fittingSize.height
    }

    // MARK: Input Accessory View

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override var inputAccessoryView: UIView? {
        return messagesInputAccessoryView
    }

    private let messagesInputAccessoryView = MessagesInputAccessoryView()

}

extension MessagesViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        return messages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                            for: indexPath) as? MessagesCell else { fatalError() }
        if indexPath.row % 2 == 0 {
            configureIncomingMessage(cell: cell)
        } else {
            configureOutgoingMessage(cell: cell)
        }
        configureMessage(cell: cell, at: indexPath)
        return cell
    }

}

extension MessagesViewController: UICollectionViewDelegate {}

extension MessagesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { fatalError() }
        let width = collectionView.bounds.width - layout.sectionInset.left - layout.sectionInset.right
        let height = heightForMessageCell(at: indexPath, width: width)
        return CGSize(width: width, height: height)
    }

}
