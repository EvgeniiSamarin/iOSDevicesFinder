//
//  Fonts.swift
//  PDP
//
//  Created by Евгений Самарин on 30.03.2022.
//

import UIKit

enum FontType {

    // MARK: - Case Enumeration

    case regular
    case bold
    case semibold
}

extension UIFont {

    // MARK: - Nested Types

    private enum FontError {

        static let loadFontError = "Failed to load font"
    }

    // MARK: - Instance Methods

    static func font(ofSize size: CGFloat, forTextStyle style: UIFont.TextStyle, forType type: FontType) -> UIFont {
        switch type {
        case .regular:
            return UIFontMetrics(forTextStyle: style).scaledFont(for: nunitoRegular(ofSize: size))

        case .bold:
            return UIFontMetrics(forTextStyle: style).scaledFont(for: nunitoBold(ofSize: size))

        case .semibold:
            return UIFontMetrics(forTextStyle: style).scaledFont(for: nunitoSemiBold(ofSize: size))
        }
    }

    // MARK: -

    private static func nunitoRegular(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Nunito-Regular", size: size) else {
            assertionFailure(FontError.loadFontError)
            return .systemFont(ofSize: size)
        }
        return font
    }

    private static func nunitoBold(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Nunito-Bold", size: size) else {
            assertionFailure(FontError.loadFontError)
            return .systemFont(ofSize: size)
        }
        return font
    }

    private static func nunitoSemiBold(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Nunito-SemiBold", size: size) else {
            assertionFailure(FontError.loadFontError)
            return .systemFont(ofSize: size)
        }
        return font
    }
}
