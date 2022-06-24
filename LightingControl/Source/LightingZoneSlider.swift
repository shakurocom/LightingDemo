//
//  LightingZoneSlider.swift
//  ShakuroApp
//
//  Created by o on 04.08.2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

class LightingZoneSlider: UIView {

    private let slider = CustomSliderView()

    var value: Float {
        get {
            return slider.value
        }
        set {
            slider.value = min(max(newValue, 0), maxValue)
        }
    }

    var maxValue: Float = 1 {
        didSet {
            if value > maxValue {
                value = maxValue
            }
        }
    }

    var minimumTrackColor: UIColor? {
        get {
            return slider.minimumTrackColor
        }
        set {
            slider.minimumTrackColor = newValue
        }
    }

    var maximumTrackColor: UIColor? {
        get {
            return slider.maximumTrackColor
        }
        set {
            slider.maximumTrackColor = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(gestureRecognizer is UIPanGestureRecognizer)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(touches: touches, moved: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(touches: touches, moved: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(touches: touches, moved: false)
    }

    func incrementValueBy(_ newValue: Float) {
        value += newValue
    }

    private func setup() {
        backgroundColor = .clear
        slider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(slider)
        slider.widthAnchor.constraint(equalToConstant: 7).isActive = true
        slider.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        slider.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        slider.rightRadius = 3.5
        slider.leftRadius = 3.5
        slider.maximumTrackColor = Stylesheet.Color.black1
        slider.minimumTrackColor = Stylesheet.Color.red
        slider.orientation = .vertical
        slider.isUserInteractionEnabled = false
    }

    private func update(touches: Set<UITouch>, moved: Bool) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        maxValue = min(max(Float(1.0 - (location.y / bounds.height)), 0), 1)
        slider.value = maxValue

    }

}
