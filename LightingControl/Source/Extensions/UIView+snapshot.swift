//
//  UIView+snapshot.swift
//  ShakuroApp
//
//  Created by Sergey on 17/07/2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

extension UIView {

    func blurredSnapshot(withBlurRadius radius: CGFloat, andTintColor tintColor: UIColor = UIColor.black.withAlphaComponent(0.5)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1.0)

        var snapshot: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: -frame.origin.x, y: -frame.origin.y)
            drawHierarchy(in: bounds, afterScreenUpdates: false)
            snapshot = UIImage.blurredImage(blurRadius: radius, tintColor: tintColor, context: context, scale: 1.0)
        }
        UIGraphicsEndImageContext()
        return snapshot
    }

}

extension UIImageView {

    func generateBlurredImage(_ radius: CGFloat = 32.0, tintColor: UIColor = UIColor.black.withAlphaComponent(0.0)) -> UIImage? {
        guard let actualImage: UIImage = image else {
            return nil
        }
        let imageSize: CGSize = actualImage.size
        let viewSize: CGSize = bounds.size
        let aspectFitScale: CGFloat = min(max(viewSize.width / imageSize.width, viewSize.height / imageSize.height), 1.0)
        let drawImageRect: CGRect = CGRect(x: 0, y: 0, width: imageSize.width * aspectFitScale, height: imageSize.height * aspectFitScale)
        UIGraphicsBeginImageContextWithOptions(drawImageRect.size, false, 1.0)
        let snapshot: UIImage?
        if let effectInContext: CGContext = UIGraphicsGetCurrentContext() {
            actualImage.draw(in: drawImageRect)
            snapshot = UIImage.blurredImage(blurRadius: radius, tintColor: tintColor, context: effectInContext, scale: 1)
        } else {
            snapshot = nil
        }
        UIGraphicsEndImageContext()
        return snapshot
    }

}
