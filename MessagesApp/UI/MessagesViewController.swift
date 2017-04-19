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
        setupCollectionView()
    }

    // MARK: CollectionView

    let collectionViewLayout = UICollectionViewFlowLayout()

    private func setupCollectionView() {
        messagesView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        messagesView.collectionView.dataSource = self
        messagesView.collectionView.delegate = self
        messagesView.collectionView.collectionViewLayout = collectionViewLayout
    }

}

extension MessagesViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        return 100
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }

}

extension MessagesViewController: UICollectionViewDelegate {}

extension MessagesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

}
