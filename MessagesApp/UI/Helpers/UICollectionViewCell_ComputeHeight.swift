import UIKit

extension UICollectionViewCell {

    func prepareForComputingHeight() {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setNeedsLayout()
        layoutIfNeeded()
        prepareForReuse()
    }

    func computeHeight(forWidth width: CGFloat) -> CGFloat {
        bounds = {
            var bounds = self.bounds
            bounds.size.width = width
            return bounds
        }()
        setNeedsLayout()
        layoutIfNeeded()
        let targetSize = CGSize(width: width, height: 0)
        let fittingSize = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: UILayoutPriorityDefaultHigh,
            verticalFittingPriority: UILayoutPriorityFittingSizeLevel
        )
        return fittingSize.height
    }

}
