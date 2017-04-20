import UIKit

class MessagesCollectionViewController: UICollectionViewController {

    init() {
        super.init(collectionViewLayout: Factory.collectionViewLayout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
    }

}

extension MessagesCollectionViewController {

    struct Factory {

        static var collectionViewLayout: UICollectionViewFlowLayout {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return layout
        }

    }

}
