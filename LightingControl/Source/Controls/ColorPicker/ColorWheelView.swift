//
//  ColorWheel.swift
//  ShakuroApp
//
//  Created by Sergey on 16/07/2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

protocol ColorWheelViewDelegate: AnyObject {
    func colorHweelView(wheelView: ColorWheelView, didChangeColor color: UIColor)
}

class ColorWheelView: UIView {

    private let wheelLayer = CALayer()
    private let indicatorLayer = CAShapeLayer()
    private let indicatorRadius: CGFloat = 12.0

    private var hsvColor: HSVColor = HSVColor()
    private var indicatorPosition: CGPoint = .zero {
        didSet {
            drawIndicator()
        }
    }

    weak var delegate: ColorWheelViewDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        indicatorLayer.strokeColor = UIColor.white.cgColor
        indicatorLayer.lineWidth = 2.0
        indicatorLayer.fillColor = UIColor.clear.cgColor
        indicatorLayer.shadowColor = UIColor.black.cgColor
        indicatorLayer.shadowOpacity = 0.5
        indicatorLayer.shadowRadius = 10.0
        indicatorLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)

        layer.addSublayer(wheelLayer)
        layer.addSublayer(indicatorLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !bounds.size.equalTo(wheelLayer.frame.size) {
            wheelLayer.frame = bounds
            wheelLayer.contents = createColorWheel(for: bounds.size)
            indicatorPosition = position(at: hsvColor)
        }
    }

    func setColor(_ color: UIColor, animated: Bool = false) {
        hsvColor = HSVColor.fromUIColor(color)

        let point = position(at: hsvColor)
        if animated {
            let animation = CABasicAnimation(keyPath: "path")

            animation.duration = 0.2
            animation.fromValue = indicatorLayer.path
            animation.toValue = indicatorLayerPath(at: point)
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.isRemovedOnCompletion = true

            indicatorLayer.add(animation, forKey: nil)
        }
        indicatorPosition = point
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }
}

// MARK: - Private

private extension ColorWheelView {
    private func touchHandler(_ touches: Set<UITouch>) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        let point = fixIndicatorPosition(location)

        hsvColor = pixelColor(at: point * UIScreen.main.scale)
        indicatorPosition = point
        delegate?.colorHweelView(wheelView: self, didChangeColor: hsvColor.toUIColor())
    }

    private func indicatorLayerPath(at center: CGPoint) -> CGPath {
        var indicatorFrame: CGRect = .zero

        indicatorFrame.origin.x = center.x - indicatorRadius
        indicatorFrame.origin.y = center.y - indicatorRadius
        indicatorFrame.size.width = indicatorRadius * 2.0
        indicatorFrame.size.height = indicatorRadius * 2.0

        return UIBezierPath(roundedRect: indicatorFrame, cornerRadius: indicatorRadius).cgPath
    }

    private func drawIndicator() {
        indicatorLayer.path = indicatorLayerPath(at: indicatorPosition)
        indicatorLayer.fillColor = hsvColor.toUIColor().cgColor
    }

    private func fixIndicatorPosition(_ position: CGPoint) -> CGPoint {
        let dimension = min(wheelLayer.frame.width, wheelLayer.frame.height)
        let radius = dimension * 0.5
        let wheelCenter = CGPoint(x: wheelLayer.frame.origin.x + radius, y: wheelLayer.frame.origin.y + radius)

        let deltaX = position.x - wheelCenter.x
        let deltaY = position.y - wheelCenter.y
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)

        var outputPosition = position
        if distance > radius {
            let theta = atan2(deltaY, deltaX)

            outputPosition.x = radius * cos(theta) + wheelCenter.x
            outputPosition.y = radius * sin(theta) + wheelCenter.y
        }
        return outputPosition
    }

    private func position(at color: HSVColor) -> CGPoint {
        let halfDim = min(wheelLayer.frame.width, wheelLayer.frame.height) * 0.5
        let radius = color.saturation * halfDim
        let xPos = halfDim + radius * cos(color.hue * .pi * 2)
        let yPos = halfDim + radius * sin(color.hue * .pi * 2)

        return CGPoint(x: xPos, y: yPos)
    }

    func pixelColor(at point: CGPoint) -> HSVColor {
        let center: CGFloat = (wheelLayer.frame.width * UIScreen.main.scale) * 0.5
        let deltaX: CGFloat = (point.x - center) / center
        let deltaY: CGFloat = (point.y - center) / center
        let distance = sqrt((deltaX * deltaX + deltaY * deltaY))
        let saturation: CGFloat = distance

        var hue: CGFloat = 0.0
        if distance != 0.0 {
            hue = (acos(deltaX / distance) / .pi) * 0.5
            if deltaY < 0.0 {
                hue = 1.0 - hue
            }
        }
        return HSVColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
    }

    private func createColorWheel(for size: CGSize) -> CGImage? {
        let dimension = min(size.width * UIScreen.main.scale, size.height * UIScreen.main.scale)
        let bufferLength = Int(dimension * dimension * 4.0)

        let bitmapData: CFMutableData = CFDataCreateMutable(nil, 0)
        CFDataSetLength(bitmapData, CFIndex(bufferLength))
        let bitmap = CFDataGetMutableBytePtr(bitmapData)

        stride(from: 0.0, to: dimension, by: 1.0).forEach { yPos in
            stride(from: 0.0, to: dimension, by: 1.0).forEach { xPos in
                let hsvColor = pixelColor(at: CGPoint(x: xPos, y: yPos))
                let offset = Int(4 * (xPos + yPos * dimension))

                var rgbaColor = RGBAColor()
                if hsvColor.saturation < 1.0 {
                    hsvColor.alpha = hsvColor.saturation > 0.99 ? (1.0 - hsvColor.saturation) * 100.0 : 1.0
                    rgbaColor = hsvColor.toRGBAColor()
                }
                bitmap?[offset + 0] = UInt8(rgbaColor.red * 255)
                bitmap?[offset + 1] = UInt8(rgbaColor.green * 255)
                bitmap?[offset + 2] = UInt8(rgbaColor.blue * 255)
                bitmap?[offset + 3] = UInt8(rgbaColor.alpha * 255)
            }
        }

        var cgImage: CGImage?
        if let dataProvider = CGDataProvider(data: bitmapData) {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.last.rawValue)
            cgImage = CGImage(width: Int(dimension),
                              height: Int(dimension),
                              bitsPerComponent: 8,
                              bitsPerPixel: 32,
                              bytesPerRow: Int(dimension) * 4,
                              space: colorSpace,
                              bitmapInfo: bitmapInfo,
                              provider: dataProvider,
                              decode: nil,
                              shouldInterpolate: false,
                              intent: CGColorRenderingIntent.defaultIntent)
        }
        return cgImage
    }
}
