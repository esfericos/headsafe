//
//  Colors.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 05/09/24.
//

import SwiftUI
import UIKit

// MARK: - Public Constants
public extension UIColor {

    static let customGray = colorFromAsset(.customGray)

    /// UIColor to SwiftUI Color
    var asColor: Color { Color(self) }
}

// MARK: - Private Methods
private extension UIColor {
    
    static func colorFromAsset(_ assetColorIdentifier: AssetColorIdentifier) -> UIColor {
        guard let color = UIColor(named: assetColorIdentifier.rawValue, in: nil, compatibleWith: nil) else {
            fatalError("Verify the color name and be sure it's contained in Assets")
        }
        return color
    }
    
    // MARK: - Private Enum
    enum AssetColorIdentifier: String {
        case customGray = "customgray"
    }
}


