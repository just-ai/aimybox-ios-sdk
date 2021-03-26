import Aimybox

final
class SuggestionView: UIStackView {

    var suggestions: [ButtonReply] = [
        SuggestionReply(text: "Какая погода будет завтра"),
        SuggestionReply(text: "Какой курс акций ВТБ?"),
        SuggestionReply(text: "Какой курс доллара?"),
        SuggestionReply(text: "Давай переведем деньги"),
    ] {
        didSet {
            isHidden = suggestions.isEmpty
            titleLabel.isHidden = true
            updateUI()
            setNeedsLayout()
            asyncAfter(delay: 0.01) {
                self.suggestionsStackView.distribution = self.scrollView.frame.width < self.scrollView.contentSize.width
                    ? .fill
                    : .fillEqually
            }
        }
    }

    var onTapHandler: ((String) -> Void)?

    private
    let titleLabel = UILabel().with {
        $0.attributedText = "Чем я могу помочь?".attributed(style: .heading5, textColor: .black)
    }

    private
    lazy var scrollView = UIScrollView().with {
        $0.addSubview(suggestionsStackView)
        $0.clipsToBounds = false
        $0.showsHorizontalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private
    let suggestionsStackView = makeHorizontslStackView().with {
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 10
    }

    init() {
        super.init(frame: .zero)

        alignment = .fill
        axis = .vertical
        distribution = .fill
        spacing = 15
        translatesAutoresizingMaskIntoConstraints = false

        [titleLabel, scrollView].forEach(addArrangedSubview)

        suggestionsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).activate()
        suggestionsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).activate()
        suggestionsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).activate()
        suggestionsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).activate()
        suggestionsStackView.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor).activate()

        scrollView.heightAnchor.constraint(equalToConstant: 40).activate()
        scrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
            .activate(usingPriority: .defaultHigh)
        updateUI()
    }

    @available(*, unavailable)
    required
    init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private
    func updateUI() {
        let buttons = suggestions.map { suggestion in
            UIButton().with {
                $0.addTarget(self, action: #selector(onTap(sender:)), for: .touchUpInside)
                $0.setAttributedTitle(
                    suggestion.text.attributed(style: .bubbleTitle, textColor: .init(hex: 0x4D83E9)),
                    for: .normal
                )
                $0.heightAnchor.constraint(equalToConstant: 40).activate()
                $0.layer.borderColor = UIColor(hex: 0x4D83E9).cgColor
                $0.layer.borderWidth = 1
                $0.layer.cornerRadius = 10
                $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            }
        }
        suggestionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.forEach(suggestionsStackView.addArrangedSubview)
    }

    @objc
    private
    func onTap(sender: UIButton) {
        guard let text = sender.titleLabel?.text else {
            return
        }
        onTapHandler?(text)
    }

}
