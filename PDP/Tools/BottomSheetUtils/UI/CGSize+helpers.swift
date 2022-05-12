//
//  CGSize+helpers.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//

import CoreGraphics

extension CGSize {
    static func uniform(_ side: CGFloat) -> CGSize {
        CGSize(width: side, height: side)
    }
    
    // MARK: - Equality
    func isAlmostEqual(to other: CGSize) -> Bool {
        width.isAlmostEqual(to: other.width) && height.isAlmostEqual(to: other.height)
    }
    
    func isAlmostEqual(to other: CGSize, error: CGFloat) -> Bool {
        width.isAlmostEqual(to: other.width, error: error) && height.isAlmostEqual(to: other.height, error: error)
    }
}
