//
//  Font.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 17/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import UIKit

fileprivate extension String {
    static let fontFamily = "HelveticaNeue"
    static let UltraLight = fontFamily + "-UltraLight"
    static let Light = fontFamily + "-Light"
    static let Thin = fontFamily + "-Thin"
    static let Regular = fontFamily
    static let Medium = fontFamily + "-Medium"
    static let Bold = fontFamily + "-Bold"
    static let Italic = fontFamily + "-Italic"
}

public extension UIFont {
    
    private static func appFont(name: String, size: Int) -> UIFont {
        return UIFont(name: name, size: CGFloat(deviceSpecific(size: size)))!
    }
    
    static func ultraLightFont(with size: Int) -> UIFont {
        let font = appFont(name: .UltraLight, size: size)
        return font
    }
    
    static func lightFont(with size: Int) -> UIFont {
        let font = appFont(name: .Light, size: size)
        return font
    }
    
    static func thinFont(with size: Int) -> UIFont {
        let font = appFont(name: .Thin, size: size)
        return font
    }
    
    static func regularFont(with size: Int) -> UIFont {
        let font =  appFont(name: .Regular, size: size)
        return font
    }

    static func boldFont(with size: Int) -> UIFont {
        let font =  appFont(name: .Bold, size: size)
        return font
    }
    
    static func mediumFont(with size:Int) -> UIFont {
        let font = appFont(name: .Medium, size: size)
        return font
    }

    static func italicFont(with size: Int) -> UIFont {
        let font = appFont(name: .Italic, size: size)
        return font
    }
    
    static func deviceSpecific(size: Int) -> Int {
        return UIDevice.isIPhone5 ? Int(Double(size) * 0.9) : size
    }
    
}
