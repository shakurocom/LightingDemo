//
//  SliderContentView.swift
//  ShakuroApp
//
//  Created by Sergey on 17/07/2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

class SliderContentView: UIView {

    enum Constant {
        static let thumbWidth: CGFloat = 38.0
        static let thumbHeight: CGFloat = 8.0
        static let animationDuration: TimeInterval = 0.2
        static let animationKeyPath: String = "path"
        static let animationShadowKeyPath: String = "shadowPath"
    }

    /// Сalled when the value of the slider changes.
    var valueChanged: ((_ oldValue: CGFloat, _ newValue: CGFloat) -> Void)?

    /// Сalled when the gesture ended.
    var gestureEnded: (() -> Void)?

    /// Called when the gesture starts.
    var gestureBegin: (() -> Void)?

    private(set) var value: CGFloat = 0

    private let backgroundLayer = CAShapeLayer()
    private let contentLayer = CAShapeLayer()
    private let activeBarShadowLayer = CALayer()

    private let activeBarMaskLayer = CAShapeLayer()
    private let activeBarLayer = CAGradientLayer()

    private let separatorLayer = CAShapeLayer()
    private let thumbnailLayer = CAShapeLayer()

    private var activeBarFrame: CGRect {
        let barHeight = bounds.height * value
        let barFrame = CGRect(x: 0.0, y: bounds.height - barHeight, width: bounds.width, height: barHeight)
        return barFrame
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundLayer.frame = bounds
        let cornerRadius = bounds.size.width * 0.5
        let roundedPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        backgroundLayer.path = roundedPath
        backgroundLayer.shadowPath = roundedPath

        activeBarShadowLayer.frame = bounds
        activeBarShadowLayer.shadowPath = roundedPath

        contentLayer.frame = bounds
        contentLayer.cornerRadius = cornerRadius

        activeBarLayer.frame = bounds
        activeBarMaskLayer.frame = bounds

        separatorLayer.frame = bounds
        thumbnailLayer.frame = bounds

        udateLayerPaths(animated: false)
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(gestureRecognizer is UIPanGestureRecognizer)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        gestureBegin?()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        update(touches: touches, animated: false)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        update(touches: touches, animated: true)
        gestureEnded?()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        update(touches: touches, animated: true)
        gestureEnded?()
    }

    /// Sets the slider to the specified value.
    /// - parameter aValue: the specified value for the slider.
    /// - parameter animated: boolean. Whether to animate slider value change.
    func setValue(_ aValue: CGFloat, animated: Bool) {
        value = min(max(aValue, 0), 1)
        udateLayerPaths(animated: animated)
    }
}

// MARK: - Private

private extension SliderContentView {

    func setup() {
        isExclusiveTouch = true
        layer.addSublayer(backgroundLayer)

        backgroundLayer.masksToBounds = false
        backgroundLayer.fillColor = (UIColor(hex: "#2D191F") ?? .clear).cgColor
        backgroundLayer.shadowOpacity = 1.0
        backgroundLayer.shadowColor = (UIColor(hex: "#5c081e") ?? .clear).withAlphaComponent(0.3311).cgColor
        backgroundLayer.shadowOffset = .zero
        backgroundLayer.shadowRadius = 60

        activeBarShadowLayer.shadowOpacity = 1.0
        activeBarShadowLayer.shadowColor = (UIColor(hex: "#ed215b") ?? .clear).withAlphaComponent(0.3291).cgColor
        activeBarShadowLayer.shadowOffset = .zero
        activeBarShadowLayer.shadowRadius = 60
        backgroundLayer.addSublayer(activeBarShadowLayer)

        contentLayer.masksToBounds = true
        contentLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.addSublayer(contentLayer)

        activeBarMaskLayer.fillColor = UIColor.black.cgColor
        activeBarLayer.mask = activeBarMaskLayer
        activeBarLayer.colors = [
          UIColor(red: 0.929, green: 0.129, blue: 0.357, alpha: 1).cgColor,
          UIColor(red: 0.782, green: 0.102, blue: 0.295, alpha: 1).cgColor
        ]
        activeBarLayer.locations = [0, 1]
        activeBarLayer.startPoint = CGPoint(x: 0.5, y: 0.25)
        activeBarLayer.endPoint = CGPoint(x: 0.5, y: 0.75)

        separatorLayer.fillColor = UIColor.white.cgColor
        thumbnailLayer.fillColor = UIColor.white.cgColor

        contentLayer.addSublayer(activeBarLayer)
        contentLayer.addSublayer(separatorLayer)
        contentLayer.addSublayer(thumbnailLayer)
        udateLayerPaths(animated: false)
    }

    func udateLayerPaths(animated: Bool) {
        let barFrame = activeBarFrame
        let barPath = UIBezierPath(rect: barFrame).cgPath
        let separatorPath = UIBezierPath(rect: CGRect(x: 0.0, y: barFrame.origin.y, width: bounds.width, height: 1.0)).cgPath
        let xPos = (bounds.width - Constant.thumbWidth) * 0.5
        let yPos = barFrame.origin.y - Constant.thumbHeight * 0.5
        let thumbPath = UIBezierPath(roundedRect: CGRect(x: xPos, y: yPos, width: Constant.thumbWidth, height: Constant.thumbHeight),
                                     cornerRadius: Constant.thumbHeight * 0.5).cgPath
        let shadowLayerPath = UIBezierPath(roundedRect: barFrame, cornerRadius: barFrame.size.width * 0.5).cgPath

        if animated {
            CATransaction.begin()
            animatePath(activeBarMaskLayer, toValue: barPath)
            animatePath(separatorLayer, toValue: separatorPath)
            animatePath(thumbnailLayer, toValue: thumbPath)
            animatePath(activeBarShadowLayer, toValue: shadowLayerPath, keyPath: Constant.animationShadowKeyPath)
            CATransaction.commit()
        }

        activeBarShadowLayer.shadowPath = UIBezierPath(roundedRect: barFrame, cornerRadius: barFrame.size.width * 0.5).cgPath
        activeBarMaskLayer.path = barPath
        separatorLayer.path = separatorPath
        thumbnailLayer.path = thumbPath
    }

    func animatePath(_ layer: CALayer, toValue: CGPath, keyPath: String = Constant.animationKeyPath) {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.duration = Constant.animationDuration
        animation.fromValue = layer.presentation()?.value(forKeyPath: keyPath) ?? layer.value(forKeyPath: keyPath)
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = true
        layer.add(animation, forKey: keyPath)
    }

    func update(touches: Set<UITouch>, animated: Bool) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        let newValue = 1.0 - (location.y / bounds.height)
        let oldValue = value
        setValue(newValue, animated: animated)
        valueChanged?(oldValue, newValue)
    }
}
