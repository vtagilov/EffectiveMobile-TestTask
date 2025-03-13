import UIKit

extension UILabel {
    func setStrikethroughText(_ text: String, isStrikethrough: Bool) {
        let attributes: [NSAttributedString.Key: Any] = isStrikethrough
            ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            : [:]
        
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
