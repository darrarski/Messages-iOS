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
        embed(childViewController: collectionViewController, inView: messagesView.collectionViewContainer)
        setupActions()
        loadMoreMessages()
    }

    // MARK: Child view controllers

    let collectionViewController = MessagesCollectionViewController()

    // MARK: UI Actions

    private func setupActions() {
        messagesInputAccessoryView.sendButton.addTarget(self,
                                                        action: #selector(sendButtonAction),
                                                        for: .touchUpInside)
        collectionViewController.refreshControl.addTarget(self,
                                                          action: #selector(refreshControlAction),
                                                          for: .valueChanged)
    }

    func sendButtonAction() {
        guard let text = messagesInputAccessoryView.textView.text, !text.isEmpty else { return }
        sendMessage(text)
        messagesInputAccessoryView.textView.text = nil
    }

    func refreshControlAction() {
        loadMoreMessages()
    }

    // MARK: Messages

    private let messagesPerPage = 10

    private var nextMessagesPage: Int {
        return Int(floor(Double(collectionViewController.messages.count / messagesPerPage)))
    }

    private func loadMoreMessages() {
        collectionViewController.refreshControl.beginRefreshing()
        messagesService.fetchMessages(page: nextMessagesPage, perPage: messagesPerPage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.collectionViewController.appendMessages(messages.map { MessageViewModel(message: $0) }) {
                        self?.collectionViewController.refreshControl.endRefreshing()
                    }

                case .failure(let error):
                    self?.presentError(error)
                }
            }
        }
    }

    private func sendMessage(_ text: String) {
        let outgoingMessageViewModel = OutgoingMessageViewModel(text: text)
        collectionViewController.insertOutgoingMessage(outgoingMessageViewModel)
        messagesService.sendMessage(text) { [weak self] result in
            DispatchQueue.main.async {
                self?.collectionViewController.removeOutgoingMessage(outgoingMessageViewModel)
                switch result {
                case .success(let message):
                    let messageViewModel = MessageViewModel(message: message)
                    self?.collectionViewController.insertMessage(messageViewModel)

                case .failure(let error):
                    self?.presentError(error)
                }
            }
        }
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
