import UIKit
import Shakuro_CommonTypes

public enum Stylesheet {

    // MARK: - Colors

    enum Color {
        static let background: UIColor = UIColor(hex: "#1B1C1B") ?? .clear
        static let yellow: UIColor = UIColor(hex: "#FED899") ?? .clear
        static let lightYellow: UIColor = UIColor(hex: "#F7F2D6") ?? .clear
        static let red: UIColor = UIColor(hex: "#ED215B") ?? .clear
        static let black: UIColor = UIColor(hex: "#3B3B3B") ?? .clear
        static let black1: UIColor = UIColor(hex: "#242323") ?? .clear
        static let white: UIColor = UIColor.white
    }

    // MARK: - Fonts

    enum FontFace: String {
        case montserratRegular = "Montserrat-Regular"
    }
}

// MARK: - Helpers

extension Stylesheet.FontFace {

    func fontWithSize(_ size: CGFloat) -> UIFont {
        guard let actualFont: UIFont = UIFont(name: self.rawValue, size: size) else {
            debugPrint("Can't load fon with name!!! \(self.rawValue)")
            return UIFont.systemFont(ofSize: size)
        }
        return actualFont
    }

}
