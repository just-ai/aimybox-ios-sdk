import UIKit

extension String {

    struct Style {

        let weight: UIFont.Weight

        let size: CGFloat

        let lineHeight: CGFloat

    }

    func attributed(
        style: Style,
        textColor: UIColor,
        textAlignment: NSTextAlignment? = nil
    ) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = style.lineHeight
        if let textAlignment = textAlignment {
            paragraphStyle.alignment = textAlignment
        }
        let font = UIFont.systemFont(ofSize: style.size, weight: style.weight)

        let attributes: [NSAttributedString.Key: Any?] = [
            .paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: textColor,
        ]

        return NSAttributedString(string: self, attributes: attributes.compactMapValues { $0 })
    }

}

extension String.Style {

    static var text = String.Style(weight: .medium, size: 13, lineHeight: 1.42)

    static var body = String.Style(weight: .regular, size: 13, lineHeight: 1.16)

    static var bubbleTitle = String.Style(weight: .regular, size: 15, lineHeight: 1.12)

    static var button1 = String.Style(weight: .regular, size: 16, lineHeight: 1.15)

    static var heading5 = String.Style(weight: .semibold, size: 17, lineHeight: 1.08)

    static var heading6 = String.Style(weight: .semibold, size: 15, lineHeight: 1.12)

    static var smallText = String.Style(weight: .regular, size: 11, lineHeight: 0.99)

    static var temperature = String.Style(weight: .light, size: 50, lineHeight: 0.84)

}
