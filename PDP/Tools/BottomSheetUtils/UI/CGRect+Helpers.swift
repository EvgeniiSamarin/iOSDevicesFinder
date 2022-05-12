//
//  CGRect+Helpers.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//

import CoreGraphics

public extension CGRect {

    var center: CGPoint {
        get {
            CGPoint(x: midX, y: midY)
        }
        set {
            origin = CGPoint(x: newValue.x - width * 0.5, y: newValue.y - height * 0.5)
        }
    }

    func isAlmostEqual(to other: CGRect) -> Bool {
        size.isAlmostEqual(to: other.size) && origin.isAlmostEqual(to: other.origin)
    }

    func isAlmostEqual(to other: CGRect, error: CGFloat) -> Bool {
        size.isAlmostEqual(to: other.size, error: error) && origin.isAlmostEqual(to: other.origin, error: error)
    }
}
