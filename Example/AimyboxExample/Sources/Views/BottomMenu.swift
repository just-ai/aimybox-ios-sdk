import Aimybox

final
class BottomMenu: UIView {

    enum State {
        case `default`
        case chat
        case speak
    }

    var state: State = .default {
        didSet {
            updateUI()
        }
    }

    var query: String = "" {
        didSet {
            updateQuery(query)
        }
    }

    var suggestions: [ButtonReply] {
        get { suggestionView.suggestions }
        set { suggestionView.suggestions = newValue }
    }

    private
    let startRecognition: () -> Void

    private
    let stopRecognition: () -> Void

    private
    let applayText: (String) -> Void

    private
    let textDidChange: () -> Void

    private
    let suggestionTapped: (String) -> Void

    private
    let sendButton = UIButton().with {
        $0.addTarget(self, action: #selector(sendHandler), for: .touchUpInside)
        $0.backgroundColor = .init(hex: 0x4D83E9)
        $0.heightAnchor.constraint(equalToConstant: 50).activate(usingPriority: .defaultHigh)
        $0.layer.cornerRadius = 25
        $0.widthAnchor.constraint(equalToConstant: 50).activate(usingPriority: .defaultHigh)
    }

    private
    lazy var textView = UITextView().with {
        $0.backgroundColor = .white
        $0.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 15, right: 15)
        $0.delegate = self
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.layer.borderColor = UIColor(hex: 0xF3F7FA).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.text = placeholderText
    }

    private
    lazy var internalStackView = UIStackView().with {
        $0.alignment = .trailing
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }.with {
        $0.spacing = 20
        [textView, sendButton].forEach($0.addArrangedSubview)
    }

    private
    lazy var stackView = UIStackView().with {
        $0.alignment = .trailing
        $0.axis = .vertical
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }.with {
        $0.spacing = 20
        [queryBubble, suggestionView, internalStackView].forEach($0.addArrangedSubview)
    }

    private
    lazy var queryBubble = PaddingLabel().with {
        $0.backgroundColor = .init(hex: 0xF3F7FA)
        $0.clipsToBounds = true
        $0.isHidden = true
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private
    lazy var suggestionView = SuggestionView().with {
        $0.onTapHandler = { [weak self] in
            self?.suggestionTapped($0)
        }
    }

    private
    lazy var textViewHeightConstraint = textView.heightAnchor
        .constraint(greaterThanOrEqualToConstant: defaultTextViewHeight)

    init(
        startRecognition: @escaping () -> Void,
        stopRecognition: @escaping () -> Void,
        applayText: @escaping (String) -> Void,
        textDidChange: @escaping () -> Void,
        suggestionTapped: @escaping (String) -> Void
    ) {
        self.startRecognition = startRecognition
        self.stopRecognition = stopRecognition
        self.applayText = applayText
        self.textDidChange = textDidChange
        self.suggestionTapped = suggestionTapped
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).activate(usingPriority: .defaultHigh)
        topAnchor.constraint(equalTo: stackView.topAnchor, constant: -10).activate()
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).activate()
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).activate()

        textView.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor).activate(usingPriority: .defaultLow)
        textViewHeightConstraint.activate()

        updateUI()
    }

    @available(*, unavailable)
    required
    init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func focusOnChat() {
        if textView.canBecomeFocused {
            textView.becomeFirstResponder()
        }
    }

    @objc
    private
    func sendHandler() {
        switch state {
        case .default:
            textView.resignFirstResponder()
            textView.text = placeholderText
            state = .speak
            startRecognition()
        case .chat:
            if let text = textView.text, !text.isEmpty {
                applayText(text)
            }
            textView.text = placeholderText
            updateTextViewHeight()
            textView.text = ""
            state = .default
        case .speak:
            state = .default
            stopRecognition()
        }
    }

    private
    func updateUI() {
        switch state {
        case .default:
            sendButton.setImage(UIImage(named: "mic_icon"), for: .normal)
            textView.isHidden = false
            textView.textColor = .init(hex: 0xACB6C3)
            suggestionView.isHidden = suggestions.isEmpty
            endAnimation()
        case .chat:
            sendButton.setImage(UIImage(named: "msg_icon"), for: .normal)
            textView.textColor = .black
            suggestionView.isHidden = suggestions.isEmpty
            endAnimation()
        case .speak:
            sendButton.setImage(UIImage(named: "waves_icon"), for: .normal)
            textView.isHidden = true
            updateQuery(query)
            suggestionView.isHidden = suggestions.isEmpty
            runAnimation()
        }
        setNeedsLayout()
    }

    private
    func updateQuery(_ query: String) {
        queryBubble.isHidden = query.isEmpty
        queryBubble.attributedText = query.attributed(
            style: .bubbleTitle,
            textColor: .init(hex: 0x4D83E9),
            textAlignment: .right
        )
    }

    private
    func updateTextViewHeight() {
        textViewHeightConstraint.constant = max(
            defaultTextViewHeight,
            textView.contentSize.height + textView.contentInset.top + textView.contentInset.bottom
        )
    }

    private
    func runAnimation() {
        let pulseAnimation = CASpringAnimation(keyPath: "transform.scale").with {
            $0.autoreverses = true
            $0.damping = 1.0
            $0.duration = 0.4
            $0.fromValue = 0.95
            $0.initialVelocity = 0.5
            $0.repeatCount = .infinity
            $0.toValue = 1.1
        }
        sendButton.layer.add(pulseAnimation, forKey: nil)
    }

    private
    func endAnimation() {
        sendButton.layer.removeAllAnimations()
    }

}

extension BottomMenu: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        state = .default
        updateTextViewHeight()
    }

    func textViewDidChange(_ textView: UITextView) {
        setNeedsLayout()
        updateTextViewHeight()
        state = (textView.text?.isEmpty ?? true) ? .default : .chat
    }

}

private
let placeholderText = "Или введите запрос здесь"

private
let defaultTextViewHeight: CGFloat = 50
