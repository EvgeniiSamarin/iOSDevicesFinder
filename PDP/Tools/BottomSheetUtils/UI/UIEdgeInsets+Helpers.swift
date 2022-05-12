//
//  UIEdgeInsets+Helpers.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//

import UIKit

public extension UIEdgeInsets {
    // MARK: - Public properties
    @inlinable
    var horizontalInsets: CGFloat {
        left + right
    }

    @inlinable
    var verticalInsets: CGFloat {
        top + bottom
    }
}
