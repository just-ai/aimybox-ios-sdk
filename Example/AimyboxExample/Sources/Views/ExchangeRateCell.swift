import UIKit

final
class ExchangeRateCell: UITableViewCell {

    var exchangeRateReply: ExchangeRateReply? {
        didSet {
            rateViews = exchangeRateReply?.values.map { value -> UIView in
                let keyLabel = UILabel().with {
                    $0.attributedText = value.name.attributed(style: .bubbleTitle, textColor: .init(hex: 0x2F3440))
                }

                let valueLabel = UILabel().with {
                    $0.attributedText = "\(value.exchangeRate)"
                        .attributed(style: .bubbleTitle, textColor: .init(hex: 0x2F3440))
                }
                return makeHorizontslStackView(arrangedSubviews: [keyLabel, valueLabel])
            } ?? []
        }
    }

    private
    var rateViews: [UIView] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            rateViews.forEach { stackView.addArrangedSubview($0) }
        }
    }

    private
    let keyTitleLabel = UILabel().with {
        $0.attributedText = "Обмен валют".attributed(style: .text, textColor: .init(hex: 0x6D7682))
    }

    private
    let valueTitleLabel = UILabel().with {
        $0.attributedText = "По курсу ЦБ".attributed(style: .text, textColor: .init(hex: 0x6D7682))
    }

    private
    lazy var stackView = makeVerticalStackView().with {
        $0.backgroundColor = .init(hex: 0xF3F7FA)
        $0.clipsToBounds = true
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layer.cornerRadius = 10
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 25, right: 15)
        $0.spacing = 11

        let titleStack = makeHorizontslStackView(arrangedSubviews: [keyTitleLabel, valueTitleLabel])
        $0.addArrangedSubview(titleStack)
    }

    override
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(stackView)
        buildConstraintsAsForCard(parent: contentView, child: stackView)
    }

    @available(*, unavailable)
    required
    init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
