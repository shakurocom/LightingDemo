//
//  LightingViewController.swift
//  ShakuroApp
//
//  Created by Sergey on 14/07/2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

class LightingViewController: UIViewController {

    struct Option {}

    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var brightnessSlider: BrightnessSliderView!

    private var selectedZones: Set<LightingZoneView> = []
    private var allZones: Set<LightingZoneView> = []

    private var feedbackGenerator: UISelectionFeedbackGenerator?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        brightnessSlider.value = 1
        view.backgroundColor = Stylesheet.Color.background
        LightingZoneList.generate().forEach { lightingZone in
            if let subview = R.nib.lightingZoneView(owner: nil) {
                subview.lightingName = lightingZone.name
                subview.lightingColor = lightingZone.lightingColor
                subview.lightingCount = lightingZone.lightingCount
                subview.maxBrightness = lightingZone.type.defaultBrightness
                subview.brightness = lightingZone.type.defaultBrightness

                subview.didTapColorButtonClosure = { [weak self] zoneView in
                    self?.showColorPickerController(zoneView)
                }
                subview.selectionChanged = { [weak self] zoneView in
                    if zoneView.isSelected {
                        self?.selectedZones.insert(zoneView)
                    } else {
                        self?.selectedZones.remove(zoneView)
                    }
                }
                allZones.insert(subview)
                stackView.addArrangedSubview(subview)
            }
        }

        brightnessSlider.gestureBegin = { [weak self] in
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            self?.feedbackGenerator = generator
        }

        brightnessSlider.gestureEnded = { [weak self] in
            self?.feedbackGenerator = nil
        }

        var valueCounter: CGFloat = 0.0
        brightnessSlider.valueChanged = { [weak self] (oldValue, newValue) in
            guard let actualSelf = self else {
                return
            }

            let zonesToChange = actualSelf.selectedZones.isEmpty ? actualSelf.allZones : actualSelf.selectedZones
            zonesToChange.forEach({ $0.incrementBrightnessBy(value: Float(newValue - oldValue)) })

            if oldValue > 0.0 && oldValue < 1.0 {
                valueCounter += abs(newValue - oldValue)
                    if valueCounter >= 0.05 {
                        actualSelf.feedbackGenerator?.selectionChanged()
                        actualSelf.feedbackGenerator?.prepare()
                        valueCounter = 0.0
                }
            }
        }
    }

}

// MARK: - Private

private extension LightingViewController {

    func showColorPickerController(_ lightingZoneView: LightingZoneView) {
        let didChangeColorClosure: (UIColor) -> Void = { [weak self] color in
            self?.stackView.arrangedSubviews.lazy.compactMap({ $0 as? LightingZoneView }).first(where: { $0 == lightingZoneView })?.lightingColor = color
        }
        _ = self.router?.presentViewController(
            type: ColorPickerController.self,
            options: ColorPickerController.Option(
                lightingName: lightingZoneView.lightingName,
                lightingColor: lightingZoneView.lightingColor,
                lightingCount: lightingZoneView.lightingCount,
                didChangeColorClosure: didChangeColorClosure),
            from: self,
            style: .modal(transitionStyle: nil, completion: nil),
            animated: false)
    }

}
