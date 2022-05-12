//
//  BinaryFloatingPoint+Helpers.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//

import Foundation

public extension BinaryFloatingPoint {
    func isAlmostEqual(to other: Self) -> Bool {
        abs(self - other) < abs(self + other).ulp
    }

    func isAlmostEqual(to other: Self, accuracy: Self) -> Bool {
        abs(self - other) < (abs(self + other) * accuracy).ulp
    }

    func isAlmostEqual(to other: Self, error: Self) -> Bool {
        abs(self - other) <= error
    }
}
