import UIKit


struct AppColors {
    
    // MARK: - Tint Color
    
    /// Tint brand color
    static var tint: UIColor {
        UIColor(hex: "#362C6A") ?? .systemPurple
    }
    
    // MARK: - Background Colors
    
    /// Main background color
    static var background: UIColor {
        .black
    }
    
    /// Main background color
    static var secondaryBackground: UIColor {
        UIColor(hex: "#1B1D22") ?? .darkGray
    }
    
    // MARK: - Text Colors
    
    /// Primary text color
    static var primaryText: UIColor {
        UIColor(hex: "#FAFAFA") ?? .white
    }
    
    /// Secondary text color
    static var secondaryText: UIColor {
        UIColor(hex: "#BDBDBD") ?? .secondaryLabel
    }
    
    /// Tertiary text color (system secondary label)
    static var tertiaryText: UIColor {
        .secondaryLabel
    }
    
    // MARK: - Component Colors
    
    /// Rating stars color
    static var ratingStars: UIColor {
        UIColor(hex: "#FEC03E") ?? .yellow
    }

    
    /// Annotation border color
    static var annotationBorder: UIColor {
        UIColor(hex: "#E0E0E0") ?? .lightGray
    }
    
    

    
    
}

