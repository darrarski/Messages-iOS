import UIKit

class MessagesCollectionViewLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        return modifiedAttributes(attributes)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: reversedRect(for: rect)) else { return nil }
        return attributes.map { modifiedAttributes($0) }
    }

    // MARK: Private

    private func modifiedAttributes(_ attr: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let copy = attr.copy() as? UICollectionViewLayoutAttributes else { fatalError() }
        copy.center = reversedPoint(for: copy.center)
        return copy
    }

    private func reversedPoint(for point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x, y: reversedY(for: point.y))
    }

    private func reversedY(for y: CGFloat) -> CGFloat {
        return collectionViewContentSize.height - y
    }

    private func reversedRect(for rect: CGRect) -> CGRect {
        let size = rect.size
        let normalTopLeft = rect.origin
        let reversedBottomLeft = reversedPoint(for: normalTopLeft)
        let reversedTopLeft = CGPoint(x: reversedBottomLeft.x, y: reversedBottomLeft.y - size.height)
        let reversedRect = CGRect(origin: reversedTopLeft, size: size)
        return reversedRect
    }

}
