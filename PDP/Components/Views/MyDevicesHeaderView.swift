//
//  MyDevicesHeaderView.swift
//  PDP
//
//  Created by Евгений Самарин on 30.03.2022.
//

import UIKit

class MyDevicesHeaderView: UICollectionReusableView {

    // MARK: - Subviews

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(ofSize: 24, forTextStyle: .caption2, forType: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .adaptedFor(light: .white, dark: .white)
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance Methods

    private func setup() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(36)
        }
    }

    // MARK: - 

    @discardableResult
    func updated(with title: String) -> Self {
        titleLabel.text = title
        return self
    }
}

