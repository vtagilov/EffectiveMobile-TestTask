import UIKit

extension UIImage {
    static func symbol(_ name: String, size: CGFloat, weight: UIImage.SymbolWeight = .regular) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: weight)
        return UIImage(systemName: name, withConfiguration: config)
    }
}
