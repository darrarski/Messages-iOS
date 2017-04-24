import UIKit

extension UIScrollView {

    var reversedContentOffset: CGPoint {
        get { return reversedContentOffset(for: contentOffset) }
        set { contentOffset = reversedContentOffset(for: newValue) }
    }

    func setReversedContentOffset(_ reversedContentOffset: CGPoint, animated: Bool) {
        setContentOffset(self.reversedContentOffset(for: reversedContentOffset), animated: animated)
    }

    private func reversedContentOffset(for contentOffset: CGPoint) -> CGPoint {
        return CGPoint(
            x: contentSize.width - contentOffset.x - min(visibleSize.width, contentSize.width),
            y: contentSize.height - contentOffset.y - min(visibleSize.height, contentSize.height)
        )
    }

    private var visibleSize: CGSize {
        return CGSize(
            width: frame.width - contentInset.left - contentInset.right,
            height: frame.height - contentInset.top - contentInset.bottom
        )
    }

}
