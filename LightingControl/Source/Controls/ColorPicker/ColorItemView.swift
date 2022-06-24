//
//  ColorItem.swift
//  ShakuroApp
//
//  Created by Sergey on 16/07/2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

class ColorItemView: UIView {

    @IBOutlet private var circleView: UIView!

    var color: UIColor = .clear {
        didSet {
            circleView.backgroundColor = color
        }
    }

    var isSelected: Bool = false {
        didSet {
            if oldValue != isSelected {
                layer.borderWidth = isSelected ? 1.0 : 0.0
            }
        }
    }

    var didTapClosure: ((ColorItemView) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.masksToBounds = true
        layer.cornerRadius = 24.0
        layer.borderWidth = 0.0
        layer.borderColor = (UIColor(hex: "#3B3B3B") ?? .clear).cgColor

        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = 12.0
    }

    func reset() {
        isSelected = false
    }
}

// MARK: - Actions

private extension ColorItemView {
    @IBAction private func didTapOnItem() {
        didTapClosure?(self)
    }
}
