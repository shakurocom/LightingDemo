//
//  Bundle+BundleHelper.swift
//

import Foundation
import Shakuro_CommonTypes

extension Bundle {
    
    static let lightingBundleHelper: BundleHelper = {
        let bundleHelper = BundleHelper(targetClass: LightingViewController.self, bundleName: "Lighting")
        bundleHelper.registerFont(name: "Montserrat-Regular", fontExtension: "ttf")
        return bundleHelper
    }()

}
