//
//  ColorPickerController.swift
//  ShakuroApp
//
//  Created by Sergey on 15/07/2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

class ColorPickerController: UIViewController {

    private enum Constants {
        static let duration: TimeInterval = 0.2
    }

    static func loadFromNib() -> ColorPickerController {
        let viewController = ColorPickerController(nibName: "ColorPickerController", bundle: LightingBundleHelper.bundle)
        viewController.modalPresentationStyle = .overFullScreen
        return viewController
    }

    var lightingName: String = ""
    var lightingColor: UIColor = .white
    var lightingCount: Int = 0

    var didChangeColorClosure: ((UIColor) -> Void)?

    @IBOutlet private var blurImageView: UIImageView!
    @IBOutlet private var colorPickerView: UIView!
    @IBOutlet private var selectedColorView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subTitleLabel: UILabel!
    @IBOutlet private var colorWheelView: ColorWheelView!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        colorPickerView.backgroundColor = Stylesheet.Color.background

        selectedColorView.layer.masksToBounds = true
        selectedColorView.layer.cornerRadius = selectedColorView.bounds.height * 0.5
        selectedColorView.backgroundColor = .clear

        colorWheelView.delegate = self
        colorWheelView.backgroundColor = .clear

        titleLabel.font = Stylesheet.FontFace.montserratRegular.fontWithSize(16.0)
        titleLabel.textColor = Stylesheet.Color.white
        titleLabel.text = lightingName

        subTitleLabel.font = Stylesheet.FontFace.montserratRegular.fontWithSize(12.0)
        subTitleLabel.textColor = Stylesheet.Color.red
        subTitleLabel.text = String(format: NSLocalizedString("%@ lights turned on", comment: ""), "\(lightingCount)")

        blurImageView.alpha = 0.0
        if let window = UIApplication.shared.windows.first {
            blurImageView.image = window.blurredSnapshot(withBlurRadius: 5.44)
        }
        [(UIColor(hex: "#F7F2D6") ?? .clear),
         (UIColor(hex: "#01BCEA") ?? .clear),
         (UIColor(hex: "#FED899") ?? .clear),
         (UIColor(hex: "#BD10E0") ?? .clear),
         (UIColor(hex: "#FF4A9B") ?? .clear)
        ].forEach { color in
            if let subview = LightingBundleHelper.bundle.loadNibNamed("ColorItemView", owner: nil)?[0] as? ColorItemView {
                subview.color = color
                subview.isSelected = lightingColor.isEqual(color)
                subview.didTapClosure = { [weak self] colorItem in
                    self?.resetAllColorItems()
                    self?.setSelected(color: colorItem.color, updateColorWheel: true, animated: true)

                    colorItem.isSelected = true
                }
                stackView.addArrangedSubview(subview)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setSelected(color: lightingColor)
        setVisibleColorPicker(true)
    }

}

// MARK: - Private

private extension ColorPickerController {
    private func setSelected(color: UIColor, updateColorWheel: Bool = true, animated: Bool = false) {
        lightingColor = color
        if updateColorWheel {
            colorWheelView.setColor(color, animated: animated)
        }
        selectedColorView.backgroundColor = lightingColor
    }

    private func setVisibleColorPicker(_ visible: Bool) {
        bottomConstraint.constant = visible ? colorPickerView.bounds.height : 0.0
        UIView.animate(withDuration: Constants.duration, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
            self.blurImageView.alpha = visible ? 1.0 : 0.0
        }, completion: { _ in
            if !visible {
                self.dismiss(animated: true)
            }
        })
    }

    private func resetAllColorItems() {
        stackView.arrangedSubviews.compactMap({ $0 as? ColorItemView }).forEach { $0.reset() }
    }
}

// MARK: - Actions

private extension ColorPickerController {
    @IBAction private func closeButtonTapped() {
        didChangeColorClosure?(lightingColor)
        setVisibleColorPicker(false)
    }
}

// MARK: - ColorWheelViewDelegate

extension ColorPickerController: ColorWheelViewDelegate {
    func colorHweelView(wheelView: ColorWheelView, didChangeColor color: UIColor) {
        resetAllColorItems()
        setSelected(color: color, updateColorWheel: false)
    }
}
