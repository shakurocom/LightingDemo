//
//  LightingZoneType.swift
//  ShakuroApp
//
//  Created by Sergey on 14/07/2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

enum LightingZoneType: CaseIterable {
    case work
    case floor
    case reading
    case main

    var defaultBrightness: Float {
        switch self {
        case .work:
            return 0.6
        case .floor:
            return 0.4
        case .reading:
            return 0.5
        case .main:
            return 1
        }
    }
}

struct LightingZone: Equatable {
    let name: String
    let lightingCount: Int
    let lightingColor: UIColor
    let type: LightingZoneType
}

struct LightingZoneList {
    static func generate() -> [LightingZone] {
        return [
            LightingZone(name: NSLocalizedString("Work", comment: ""), lightingCount: 4, lightingColor: Stylesheet.Color.yellow, type: .work),
            LightingZone(name: NSLocalizedString("Floor", comment: ""), lightingCount: 6, lightingColor: Stylesheet.Color.red, type: .floor),
            LightingZone(name: NSLocalizedString("Reading", comment: ""), lightingCount: 2, lightingColor: Stylesheet.Color.lightYellow, type: .reading),
            LightingZone(name: NSLocalizedString("Main", comment: ""), lightingCount: 10, lightingColor: Stylesheet.Color.yellow, type: .main)
        ]
    }
}
