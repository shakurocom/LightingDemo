//
//  UIImage+Bundle.swift
//  Thermostat
//
//  Created by Eugene Klyuenkov on 23.06.2022.
//  Copyright © 2020 Shakuro. All rights reserved.

import UIKit

extension UIImage {

    static func loadImageFromBundle(name: String) -> UIImage? {
        let podBundle = Bundle(for: LightingViewController.self)
        if let url = podBundle.url(forResource: "Lighting", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        } else {
            return UIImage(named: name)
        }
    }

}
