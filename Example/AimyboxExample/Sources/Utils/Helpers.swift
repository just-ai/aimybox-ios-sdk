import UIKit

func asyncAfter(delay seconds: TimeInterval, _ block: @escaping () -> Void ) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        block()
    }
}

func buildConstraintsAsForCard(parent parentView: UIView, child childView: UIView) {
    childView.translatesAutoresizingMaskIntoConstraints = false
    parentView.bottomAnchor.constraint(equalTo: childView.bottomAnchor, constant: 10)
        .activate(usingPriority: .defaultHigh)
    parentView.topAnchor.constraint(equalTo: childView.topAnchor, constant: -10).activate()
    childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).activate()
    childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).activate()
}

func makeVerticalStackView(arrangedSubviews: [UIView] = []) -> UIStackView {
    UIStackView(arrangedSubviews: arrangedSubviews).with {
        $0.alignment = .fill
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
}

func makeHorizontslStackView(arrangedSubviews: [UIView] = []) -> UIStackView {
    UIStackView(arrangedSubviews: arrangedSubviews).with {
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
}
