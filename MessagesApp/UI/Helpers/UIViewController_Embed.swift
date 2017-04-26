import UIKit
import SnapKit

extension UIViewController {

    func embed(childViewController: UIViewController,
               inView mainView: UIView,
               makeConstraints: ((ConstraintMaker) -> Void) = { $0.edges.equalToSuperview() }) {
        addChildViewController(childViewController)
        mainView.addSubview(childViewController.view)
        childViewController.view.snp.makeConstraints(makeConstraints)
        childViewController.didMove(toParentViewController: self)
    }

    func unembed(childViewController: UIViewController) {
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }

}
