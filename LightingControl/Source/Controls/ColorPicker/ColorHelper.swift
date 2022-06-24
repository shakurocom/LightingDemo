//
//  PixelInfo.swift
//  ShakuroApp
//
//  Created by Sergey on 16/07/2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

struct RGBAColor {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat

    init(red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

final class HSVColor {
    var hue: CGFloat
    var saturation: CGFloat
    var brightness: CGFloat
    var alpha: CGFloat

    init(hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }

    func toRGBAColor() -> RGBAColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0

        toUIColor().getRed(&red, green: &green, blue: &blue, alpha: nil)
        return RGBAColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    func toUIColor() -> UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    class func fromUIColor(_ color: UIColor) -> HSVColor {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return HSVColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}
