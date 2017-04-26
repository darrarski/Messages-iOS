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
        loadMessages()
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
        loadMessages()
    }

    // MARK: Messages

    private func loadMessages() {
        collectionViewController.refreshControl.beginRefreshing()
        messagesService.fetchMessages(page: 0, perPage: 10) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.collectionViewController.updateMessages(messages.map { MessageViewModel(message: $0) }) {
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
