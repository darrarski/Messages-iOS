import UIKit

class MessagesViewController: UIViewController {

    init(messagesService: MessagesService) {
        self.messagesService = messagesService
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
        loadMessages()
        messagesInputAccessoryView.sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
    }

    // MARK: UI Actions

    func sendButtonAction() {
        guard let text = messagesInputAccessoryView.textView.text, !text.isEmpty else { return }
        sendMessage(text)
        messagesInputAccessoryView.textView.text = nil
    }

    // MARK: Messages

    private func loadMessages() {
        messagesService.fetchMessages { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.collectionViewController.messages = messages.map { MessageViewModel(message: $0) }

                case .failure(let error):
                    self?.presentError(error)
                }
            }
        }
    }

    private func sendMessage(_ text: String) {
        let outgoingMessageViewModel = createOutgoingMessage(text: text)
        messagesService.sendMessage(text) { [weak self] result in
            DispatchQueue.main.async {
                self?.removeOutgoingMessage(outgoingMessageViewModel)
                switch result {
                case .success(let message):
                    let messageViewModel = MessageViewModel(message: message)
                    self?.collectionViewController.messages.insert(messageViewModel, at: 0)

                case .failure(let error):
                    self?.presentError(error)
                }
            }
        }
    }

    private func createOutgoingMessage(text: String) -> OutgoingMessageViewModel {
        let viewModel = OutgoingMessageViewModel(text: text)
        collectionViewController.outgoingMessages.insert(viewModel, at: 0)
        return viewModel
    }

    private func removeOutgoingMessage(_ viewModel: OutgoingMessageViewModel) {
        guard let index = collectionViewController.outgoingMessages.index(where: { $0 === viewModel }) else {
            return
        }
        collectionViewController.outgoingMessages.remove(at: index)
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

    // MARK: Private

    private let messagesService: MessagesService

    private func presentError(_ error: Error) {
        let alertController = UIAlertController(title: "Error occured",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }

}
