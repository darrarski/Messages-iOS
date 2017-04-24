import UIKit

extension UIScrollView {

    var reversedContentOffset: CGPoint {
        get {
            return CGPoint(
                x: contentSize.width - contentOffset.x - min(visibleSize.width, contentSize.width),
                y: contentSize.height - contentOffset.y - min(visibleSize.height, contentSize.height)
            )
        }
        set {
            contentOffset = CGPoint(
                x: contentSize.width - newValue.x - min(visibleSize.width, contentSize.width),
                y: contentSize.height - newValue.y - min(visibleSize.height, contentSize.height)
            )
        }
    }

    private var visibleSize: CGSize {
        return CGSize(
            width: frame.width - contentInset.left - contentInset.right,
            height: frame.height - contentInset.top - contentInset.bottom
        )
    }

}
