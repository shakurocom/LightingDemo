//
//  CGPoint+Helpers.swift
//

import UIKit

extension CGPoint {

    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }

}
