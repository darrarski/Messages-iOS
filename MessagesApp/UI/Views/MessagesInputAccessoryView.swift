import UIKit
import SnapKit

class MessagesInputAccessoryView: UIToolbar {

    init() {
        super.init(frame: .zero)
        loadSubviews()
        setupLayout()
        textView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Subviews

    let textView = Factory.textView
    let sendButton = Factory.sendButton

    private func loadSubviews() {
        addSubview(textView)
        addSubview(sendButton)
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        updateTextViewHeight()
    }

    private let maxTextViewHeight: CGFloat = 150

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        textView.snp.makeConstraints {
            $0.height.equalTo(0)
            $0.top.left.equalTo(8)
            $0.bottom.equalTo(-8)
        }
        sendButton.snp.makeConstraints {
            $0.left.equalTo(textView.snp.right).offset(8)
            $0.right.bottom.equalTo(-10)
        }
        textView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        sendButton.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
    }

    fileprivate func updateTextViewHeight() {
        let computedTextViewHeight = self.computedTextViewHeight
        if computedTextViewHeight < maxTextViewHeight {
            textView.snp.updateConstraints {
                $0.height.equalTo(computedTextViewHeight)
            }
            textView.isScrollEnabled = false
        } else {
            textView.isScrollEnabled = true
        }
    }

    private var computedTextViewHeight: CGFloat {
        let textViewWidth = textView.frame.size.width
        let textViewSize = textView.sizeThatFits(CGSize(width: textViewWidth, height: CGFloat.greatestFiniteMagnitude))
        return textViewSize.height
    }

}

extension MessagesInputAccessoryView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
    }

}

extension MessagesInputAccessoryView {

    struct Factory {

        static var textView: UITextView {
            let textView = UITextView(frame: .zero)
            textView.layer.borderWidth = 0.5
            textView.layer.borderColor = UIColor.black.cgColor
            textView.layer.cornerRadius = 5
            textView.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
            return textView
        }

        static var sendButton: UIButton {
            let button = UIButton(frame: .zero)
            button.setTitle("Send", for: .normal)
            button.setTitleColor(UIColor(red:0.02, green:0.48, blue:0.96, alpha:1), for: .normal)
            return button
        }

    }

}
