//
//  SliderView.swift
//  ShakuroApp
//
//  Created by Sergey on 17/07/2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

class BrightnessSliderView: UIView {

    @IBOutlet private var contentView: SliderContentView!

    /// Сalled when the value of the slider changes.
    var valueChanged: ((_ oldValue: CGFloat, _ newValue: CGFloat) -> Void)? {
        didSet {
            contentView.valueChanged = valueChanged
        }
    }

    /// Сalled when the gesture ended.
    var gestureEnded: (() -> Void)? {
        didSet {
            contentView.gestureEnded = gestureEnded
        }
    }

    /// Called when the gesture starts.
    var gestureBegin: (() -> Void)? {
        didSet {
            contentView.gestureBegin = gestureBegin
        }
    }

    /// Сalled when the value of the slider changes.
    var value: CGFloat {
        get {
            return contentView.value
        }
        set {
            contentView.setValue(newValue, animated: false)
        }
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(gestureRecognizer is UIPanGestureRecognizer)
    }
}
