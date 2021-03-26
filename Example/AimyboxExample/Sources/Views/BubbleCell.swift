import UIKit

class BubbleCell: UITableViewCell {

    var bubbleColor: UIColor? {
        didSet {
            stackView.backgroundColor = bubbleColor
            setNeedsLayout()
        }
    }

    let titleLabel = UILabel().with {
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = true
    }

    private
    lazy var stackView = makeHorizontslStackView(arrangedSubviews: [titleLabel]).with {
        $0.addArrangedSubview(titleLabel)
        $0.clipsToBounds = true
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        $0.distribution = .fill
        $0.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }

    override
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(stackView)

        contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10)
            .activate(usingPriority: .defaultHigh)
        contentView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -10).activate()
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).activate()
        stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20)
            .activate(usingPriority: .defaultHigh)
    }

    @available(*, unavailable)
    required
    init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
