//
//  NavigationBar.swift
//  PDP
//
//  Created by Евгений Самарин on 15.05.2022.
//

import UIKit

final class NavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    private func setup() {
        let appearance = UINavigationBarAppearance()

        appearance.backgroundColor = .adaptedFor(light: .darkPurple, dark: .darkPurple)
        appearance.setBackIndicatorImage(.backIcon, transitionMaskImage: .backIcon)

        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.adaptedFor(light: .primaryWhite, dark: .primaryWhite),
            .font: UIFont.font(ofSize: 34, forTextStyle: .largeTitle, forType: .bold)
        ]

        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.adaptedFor(light: .primaryWhite, dark: .primaryWhite),
            .font: UIFont.font(ofSize: 17, forTextStyle: .headline, forType: .bold)
        ]

        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.adaptedFor(light: .primaryWhite, dark: .primaryWhite),
            .font: UIFont.font(ofSize: 17, forTextStyle: .body, forType: .semibold)
        ]

        appearance.buttonAppearance = buttonAppearance
        appearance.shadowColor = .clear
        tintColor = .adaptedFor(light: .primaryWhite, dark: .primaryWhite)
        compactAppearance = appearance
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
        prefersLargeTitles = true
    }
}
