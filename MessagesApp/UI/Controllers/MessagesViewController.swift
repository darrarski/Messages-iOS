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
        collectionViewController.messages = loadMessages()
    }

    // MARK: Messages

    private func loadMessages() -> [MessageViewModel] {
        let bundle = Bundle(for: MessagesViewController.self)
        guard let path = bundle.path(forResource: "quotes", ofType: "json") else { fatalError() }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else { fatalError() }
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let jsonArray = jsonObject as? [[String]] else { fatalError() }
        let quotes = jsonArray.map { "\($0[0])\n(\($0[1]))" }
        return quotes.map { MessageViewModel(text: $0) }
    }

    // MARK: CollectionViewController

    let collectionViewController = MessagesCollectionViewController()

    private func embedCollectionViewController() {
        addChildViewController(collectionViewController)
        messagesView.collectionViewContainer.addSubview(collectionViewController.view)
        collectionViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        collectionViewController.didMove(toParentViewController: self)
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
