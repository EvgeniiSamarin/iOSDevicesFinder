//
//  UIColor+Extensions.swift
//  PDP
//
//  Created by Евгений Самарин on 17.03.2022.
//

import UIKit

extension UIColor {

    // MARK: - Instance Methods

    static func adaptedFor(light: UIColor, dark: UIColor) -> Self {
        Self { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }
    }
}
