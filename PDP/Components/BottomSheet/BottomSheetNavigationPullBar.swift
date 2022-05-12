//
//  BottomSheetNavigationPullBar.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//

import UIKit

public extension BottomSheetPresentationController {

    // MARK: - PullBar

    final class PullBar: UIView {
        enum Style {
            static let size = CGSize(width: 82, height: 4)
        }

        private let centerView: UIView = {
            let view = UIView()
            view.frame.size = Style.size
            view.backgroundColor = .white
            view.layer.cornerRadius = Style.size.height * 0.5
            return view
        }()

        init() {
            super.init(frame: .zero)

            backgroundColor = .clear

            setupSubviews()
        }

        required init?(coder: NSCoder) {
            preconditionFailure("init(coder:) has not been implemented")
        }

        private func setupSubviews() {
            addSubview(centerView)
        }

        public override func layoutSubviews() {
            super.layoutSubviews()

            centerView.center = bounds.center
        }
    }
}
