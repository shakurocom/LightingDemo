//
//  UIImage+Bundle.swift
//  Copyright © 2020 Shakuro. All rights reserved.

import UIKit

extension UIImage {

    static func loadImageFromBundle(name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.findBundleIfNeeded(for: LightingViewController.self), compatibleWith: nil)
    }

}
