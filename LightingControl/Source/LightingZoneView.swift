//
//  LightingView.swift
//  ShakuroApp
//
//  Created by Sergey on 14/07/2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

class LightingZoneView: UIView {

    private enum Constants {
        static let shakeAnimationDuration: TimeInterval = 0.5
        static let shakeAnimationDamping: CGFloat = 0.2
        static let shakeAnimationVelocity: CGFloat = 5.0
        static let shakeAnimationTransform: CGAffineTransform = CGAffineTransform(translationX: -15.0, y: 0.0)
    }

    @IBOutlet private var colorButton: UIButton!
    @IBOutlet private var borderView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subTitleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var heightConstraint: NSLayoutConstraint!

    @IBOutlet private var brightnessSlider: LightingZoneSlider!

    var selectionChanged: ((_ zoneView: LightingZoneView) -> Void)?

    private(set) var isSelected: Bool = false {
        didSet {
            selectionChanged?(self)
            updateViewStyle(shakeAnimation: true)
        }
    }

    var brightness: Float {
        get {
            return brightnessSlider.value
        }
        set {
            brightnessSlider.value = newValue
        }
    }

    var maxBrightness: Float {
        get {
            return brightnessSlider.maxValue
        }
        set {
            brightnessSlider.maxValue = newValue
        }
    }

    var lightingColor: UIColor = .clear {
        didSet {
            colorButton.backgroundColor = lightingColor
        }
    }

    var lightingName: String = "" {
        didSet {
            titleLabel.text = lightingName
        }
    }

    var lightingCount: Int = 0 {
        didSet {
            subTitleLabel.text = String(format: NSLocalizedString("%@ Lights", comment: ""), "\(lightingCount)")
            heightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        }
    }

    var didTapColorButtonClosure: ((LightingZoneView) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        colorButton.layer.masksToBounds = true
        colorButton.layer.cornerRadius = 12.0

        borderView.layer.masksToBounds = true
        borderView.layer.cornerRadius = 16

        titleLabel.font = Stylesheet.FontFace.montserratRegular.fontWithSize(16.0)
        subTitleLabel.font = Stylesheet.FontFace.montserratRegular.fontWithSize(12.0)

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")

        updateViewStyle(shakeAnimation: false)
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(gestureRecognizer is UIPanGestureRecognizer)
    }

    func incrementBrightnessBy(value: Float) {
        brightnessSlider.incrementValueBy(value)
    }

}

// MARK: - Actions

private extension LightingZoneView {
    @IBAction private func didTapColorButton() {
        didTapColorButtonClosure?(self)
    }

    @IBAction private func didTapBorderViewButton() {
        isSelected.toggle()
    }
}

// MARK: - Private

private extension LightingZoneView {
    private func updateViewStyle(shakeAnimation: Bool) {
        let borderViewColor: UIColor = isSelected ? Stylesheet.Color.red : .clear
        let borderWidth: CGFloat = isSelected ? 0.0 : 1.0
        let borderColor: UIColor = isSelected ? .clear : Stylesheet.Color.white.withAlphaComponent(0.5)
        let titleTextColor: UIColor = isSelected ? Stylesheet.Color.white : Stylesheet.Color.red
        let subTitleTextColor: UIColor = Stylesheet.Color.white

        brightnessSlider.minimumTrackColor = isSelected ? UIColor.white : Stylesheet.Color.red
        borderView.backgroundColor = borderViewColor
        borderView.layer.borderWidth = borderWidth
        borderView.layer.borderColor = borderColor.cgColor

        subTitleLabel.textColor = titleTextColor
        titleLabel.textColor = subTitleTextColor

        collectionView.reloadData()
        if shakeAnimation {
            colorButton.transform = Constants.shakeAnimationTransform
            UIView.animate(withDuration: Constants.shakeAnimationDuration,
                           delay: 0.0,
                           usingSpringWithDamping: Constants.shakeAnimationDamping,
                           initialSpringVelocity: Constants.shakeAnimationVelocity,
                           options: [.curveEaseInOut], animations: {
                            self.colorButton.transform = .identity
            }, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension LightingZoneView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lightingCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)

        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.backgroundColor = isSelected ? Stylesheet.Color.white : Stylesheet.Color.black

        return cell
    }

}
