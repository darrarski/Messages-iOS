import UIKit
import SnapKit

class MessagesInputAccessoryView: UIToolbar {

    init() {
        super.init(frame: .zero)
        loadSubviews()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Subviews

    let textView = Factory.textView

    private func loadSubviews() {
        addSubview(textView)
    }

    // MARK: Layout

    private func setupLayout() {
        snp.makeConstraints {
            $0.height.equalTo(44)
        }
        textView.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
    }

}

extension MessagesInputAccessoryView {

    struct Factory {

        static var textView: UITextView {
            let textView = UITextView(frame: .zero)
            textView.layer.borderWidth = 0.5
            textView.layer.borderColor = UIColor.black.cgColor
            textView.layer.cornerRadius = 5
            return textView
        }

    }

}
