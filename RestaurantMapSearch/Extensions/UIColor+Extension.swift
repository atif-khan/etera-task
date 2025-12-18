import UIKit

extension UIColor {
    
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")
        
        guard hexString.count == 6,
              let rgbValue = UInt64(hexString, radix: 16) else {
            return nil
        }
        
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8)  / 255.0
        let blue  = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }
}
