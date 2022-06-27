//
//  CGPoint+Helpers.swift
//  Lighting
//
//  Created by Eugene Klyuenkov on 24.06.2022.
//

import UIKit

extension CGPoint {

    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }

}
