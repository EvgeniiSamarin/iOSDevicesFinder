//
//  Button.swift
//  PDP
//
//  Created by Евгений Самарин on 12.05.2022.
//

import UIKit

final class Button: UIButton {

    // MARK: - Instance Properties

    // MARK: - Initializer

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.titleLabel?.textAlignment = .center
        self.applyFont()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.titleLabel?.textAlignment = .center
        self.applyFont()
    }

    // MARK: - Instance Methods

    private func applyFont() {
        self.titleLabel?.font = .font(ofSize: 20, forTextStyle: .body, forType: .bold)
    }
}
