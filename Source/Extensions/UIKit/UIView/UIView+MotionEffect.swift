//
//  UIView+MotionEffect.swift
//  Zupreme
//
//  Created by Alexander Cyon on 2018-12-21.
//  Copyright © 2018 Open Zesame. All rights reserved.
//

import UIKit

extension UIMotionEffect {
    class func twoAxesShift(strength: CGFloat) -> UIMotionEffect {
        // internal method that creates motion effect
        func motion(type: UIInterpolatingMotionEffect.EffectType) -> UIInterpolatingMotionEffect {
            let keyPath = type == .tiltAlongHorizontalAxis ? "center.x" : "center.y"
            let motion = UIInterpolatingMotionEffect(keyPath: keyPath, type: type)
            motion.minimumRelativeValue = -strength
            motion.maximumRelativeValue = strength
            return motion
        }

        // group of motion effects
        let group = UIMotionEffectGroup()
        group.motionEffects = [
            motion(type: .tiltAlongHorizontalAxis),
            motion(type: .tiltAlongVerticalAxis)
        ]
        return group
    }
}

extension UIView {
    func addMotionEffect(strength: CGFloat) {
        addMotionEffect(.twoAxesShift(strength: strength))
    }

    func addMotionEffectFromImageAssets(front: ImageAsset, middle: ImageAsset, back: ImageAsset) {
        addMotionEffectFromImages(front: front.image, middle: middle.image, back: back.image)
    }
    
    // swiftlint:disable:next function_body_length
    func addMotionEffectFromImages(front: UIImage, middle: UIImage, back: UIImage, horizontalInset: CGFloat = 80) {
        let frontImageView = UIImageView(image: front)
        let middleImageView = UIImageView(image: middle)
        let backImageView = UIImageView(image: back)

        let imageViews = [backImageView, middleImageView, frontImageView]

        imageViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = UIView.ContentMode.center
            addSubview($0)
            $0.backgroundColor = .clear
            $0.edgesToSuperview(insets:
                UIEdgeInsets(
                    top: 0,
                    left: horizontalInset,
                    bottom: 0,
                    right: horizontalInset
                )
            )
        }

        addMotionEffectTo(views: (backImageView, middleImageView, frontImageView))
    }

    // swiftlint:disable large_tuple
    // [4, 15, 40]
    // (8, 30, 50)
    func addMotionEffectTo(
        views: (back: UIView, middle: UIView, front: UIView),
        strengths: (back: CGFloat, middle: CGFloat, front: CGFloat) = (6, 20, 48)
        ) {
        let views = [views.back, views.middle, views.front]
        let strengths = [strengths.back, strengths.middle, strengths.front]
        let viewsAndEffectStrength = zip(views, strengths).map { ($0.0, $0.1) }

        addMotionEffectTo(viewsAndEffectStrength: viewsAndEffectStrength)
    }

    func addMotionEffectTo(viewsAndEffectStrength: [(UIView, CGFloat)]) {
        viewsAndEffectStrength.forEach {
            let (view, strength) = $0
            view.addMotionEffect(strength: CGFloat(strength))
        }
    }
}
