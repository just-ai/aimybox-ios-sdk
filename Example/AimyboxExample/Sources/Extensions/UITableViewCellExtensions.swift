import UIKit

extension UITableViewCell {

    static
    var defaultReuseIdentifier: String {
        String(reflecting: self)
    }

}
