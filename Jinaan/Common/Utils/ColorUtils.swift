//
//  ColorUtils.swift
//  TAPS
//
//  Created by Suhendra Ahmad on 5/11/15.
//  Copyright (c) 2015 azaSoftware. All rights reserved.
//

import UIKit

class ColorUtils: NSObject {
    class func UIColorFromRGB(rgbValue: Int) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
    
    class func UIColorFromRGBA(rgbValue: Int64) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0, green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0, blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0, alpha: CGFloat(rgbValue & 0x000000FF) / 255.0)
    }
    
    class func UIColorFromHexString(hexString: String) -> UIColor {
        var rgbValue: UInt32 = 0
        let scanner = NSScanner(string: hexString)
        scanner.scanLocation = 1
        scanner.scanHexInt(&rgbValue)
        
        let r: CGFloat = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let g: CGFloat = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
        let b: CGFloat = CGFloat(rgbValue & 0xFF)/255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
