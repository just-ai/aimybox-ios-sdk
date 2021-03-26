import UIKit

final
class ChatCell: BubbleCell {

    var userReplay: UserReply? {
        didSet {
            titleLabel.attributedText = userReplay?.text.attributed(
                style: .bubbleTitle,
                textColor: .white,
                textAlignment: .right
            )
            layoutIfNeeded()
        }
    }

    override
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        bubbleColor = .init(hex: 0x4D83E9)
    }

}
