import UIKit

final
class StockMarketCell: UITableViewCell {

    var stockMarketReply: StockMarketReply? {
        didSet {
            marketViews = stockMarketReply?.markets.map { $0.asView } ?? []
        }
    }

    private
    var marketViews: [UIView] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            marketViews.forEach { stackView.addArrangedSubview($0) }
        }
    }

    private
    let titleLabel = UILabel().with {
        $0.attributedText = "Котировки".attributed(style: .heading5, textColor: .init(hex: 0x2F3440))
    }

    private
    lazy var stackView = makeVerticalStackView().with {
        $0.backgroundColor = .init(hex: 0xF3F7FA)
        $0.clipsToBounds = true
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layer.cornerRadius = 10
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 25, right: 15)
        $0.spacing = 15

        $0.addArrangedSubview(titleLabel)
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

private
extension StockMarketReply.Market {

    var asView: UIView {
        let nameLabel = UILabel().with {
            $0.attributedText = name.attributed(style: .bubbleTitle, textColor: .init(hex: 0x2F3440))
        }
        nameLabel.widthAnchor.constraint(equalToConstant: 80).activate(usingPriority: .defaultHigh)

        let isPositive = changePercents > 0
        let color: UIColor = isPositive ? .init(hex: 0x4CC864) : .init(hex: 0xE62632)
        let icon = UIImage(named: isPositive ? "up_icon" : "down_icon")
        let iconImageView = UIImageView(image: icon).with {
            $0.tintColor = color
        }
        iconImageView.widthAnchor.constraint(equalToConstant: 7).activate()
        iconImageView.heightAnchor.constraint(equalToConstant: 10).activate(usingPriority: .defaultLow)

        let valueLabel = UILabel().with {
            $0.attributedText = "\(changePerDay.shortString)(\(changePercents.shortString)%)"
                .attributed(style: .bubbleTitle, textColor: color)
        }
        valueLabel.widthAnchor.constraint(equalToConstant: 100).activate(usingPriority: .defaultHigh)
        let midleView = makeHorizontslStackView(arrangedSubviews: [iconImageView, valueLabel]).with {
            $0.alignment = .center
            $0.spacing = 5
            $0.distribution = .fill
        }
        let priceLabel = UILabel().with {
            $0.attributedText = "\(currentPrice.shortString) ₽"
                .attributed(style: .bubbleTitle, textColor: .init(hex: 0x2F3440))
            $0.textAlignment = .right
        }
        priceLabel.widthAnchor.constraint(equalToConstant: 100).activate(usingPriority: .defaultLow)
        return makeHorizontslStackView(arrangedSubviews: [nameLabel, midleView, priceLabel]).with {
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }

}
