import UIKit

extension UITableView {

    func registerCell<T: UITableViewCell>(
        of type: T.Type,
        withReuseIdentifier reuseIdentifier: String = T.defaultReuseIdentifier
    ) {
        register(type, forCellReuseIdentifier: reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(of type: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }

}
