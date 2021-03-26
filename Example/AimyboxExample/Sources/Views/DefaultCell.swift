import Aimybox
import SDWebImage
import UIKit

final
class DefaultCell: UITableViewCell {

    var textReplay: TextReply? {
        didSet {
            descriptionLabel.attributedText = textReplay?.text.attributed(style: .body, textColor: .init(hex: 0x2F3441))
            descriptionLabel.isHidden = false
            photoView.isHidden = true
            textView.isHidden = false
            titleLabel.isHidden = true
            layoutIfNeeded()
        }
    }

    var imageReply: ImageReply? {
        didSet {
            photoView.isHidden = false
            photoView.sd_setImage(with: imageReply?.url)
            textView.isHidden = true
            titleLabel.isHidden = true
            layoutIfNeeded()
        }
    }

    var cardReply: CardReply? {
        didSet {
            let descLabelAttrs = cardReply?.description?.attributed(style: .body, textColor: .init(hex: 0x2F3441))

            descriptionLabel.attributedText = descLabelAttrs
            descriptionLabel.isHidden = cardReply?.description?.isEmpty ?? true
            photoView.isHidden = cardReply?.imageURL == nil
            photoView.sd_setImage(with: cardReply?.imageURL)
            titleLabel.isHidden = cardReply?.title?.isEmpty ?? true
            titleLabel.attributedText = cardReply?.title?.attributed(
                style: .heading5,
                textColor: .init(hex: 0x4D83E9),
                textAlignment: .center
            )
            textView.isHidden = titleLabel.isHidden && descriptionLabel.isHidden
            layoutIfNeeded()
        }
    }

    private
    let photoView = UIImageView().with {
        $0.backgroundColor = .init(hex: 0x4D83E9, alpha: 0.1)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.heightAnchor.constraint(equalToConstant: 180).activate()
    }

    private
    let textView = makeVerticalStackView().with {
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        $0.spacing = 10
    }

    private
    let titleLabel = UILabel().with {
        $0.backgroundColor = .init(hex: 0xF3F7FA)
        $0.numberOfLines = 0
    }

    private
    let descriptionLabel = UILabel().with {
        $0.numberOfLines = 0
    }

    private
    lazy var stackView = makeVerticalStackView().with {
        $0.backgroundColor = .init(hex: 0xF3F7FA)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
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
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).activate()
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).activate()

        [photoView, textView].forEach(stackView.addArrangedSubview)
        [titleLabel, descriptionLabel].forEach(textView.addArrangedSubview)
    }

    @available(*, unavailable)
    required
    init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
