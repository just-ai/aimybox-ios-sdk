import UIKit

final
class GradientView: UIView {

    override
    class var layerClass: Swift.AnyClass {
        CAGradientLayer.self
    }

    override
    var layer: CAGradientLayer {
        // swiftlint:disable:next force_cast
        super.layer as! CAGradientLayer
    }

    var colors: [UIColor]? {
        // swiftlint:disable:next force_cast
        get { layer.colors?.compactMap { UIColor(cgColor: ($0 as! CGColor)) } }
        set { layer.colors = newValue?.map { $0.cgColor } }
    }

    var startPoint: CGPoint {
        get { layer.startPoint }
        set { layer.startPoint = newValue }
    }

    var endPoint: CGPoint {
        get { layer.endPoint }
        set { layer.endPoint = newValue }
    }

}
