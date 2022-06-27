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

    var valueChanged: ((_ oldValue: CGFloat, _ newValue: CGFloat) -> Void)? {
        didSet {
            contentView.valueChanged = valueChanged
        }
    }

    var gestureEnded: (() -> Void)? {
        didSet {
            contentView.gestureEnded = gestureEnded
        }
    }

    var gestureBegin: (() -> Void)? {
        didSet {
            contentView.gestureBegin = gestureBegin
        }
    }

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
