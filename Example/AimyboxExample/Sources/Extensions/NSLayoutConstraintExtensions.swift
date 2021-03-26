import UIKit

extension NSLayoutConstraint {

    func activate(usingPriority newPriority: UILayoutPriority? = nil) {
        if let newPriority = newPriority {
            priority = newPriority
        }
        isActive = true
    }

}
