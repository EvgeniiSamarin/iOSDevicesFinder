//
//  OtherDevicesCellContentView.swift
//  PDP
//
//  Created by Евгений Самарин on 11.05.2022.
//

import Foundation
import UIKit

class OtherDevicesCellContentView: UIView, UIContentView {

    private lazy var backgroungImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightPurple
        view.layer.cornerRadius = 15
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightPurple
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    private lazy var deviceNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .font(ofSize: 20, forTextStyle: .body, forType: .bold)
        label.textColor = .white
        return label
    }()

    private lazy var deviceTypeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.adjustsFontSizeToFitWidth = true
        typeLabel.font = .font(ofSize: 16, forTextStyle: .body, forType: .regular)
        typeLabel.textColor = .lightGray
        return typeLabel
    }()

    private lazy var optionsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "OptionsButton") ?? UIImage(), for: .normal)
        return button
    }()

    private var currentConfiguration: OtherDevicesContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? OtherDevicesContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }

    init(configuration: OtherDevicesContentConfiguration) {
        super.init(frame: .zero)

        setupAllViews()

        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OtherDevicesCellContentView {
    
    private func setupAllViews() {

        self.addSubview(self.backgroungImageView)
        self.backgroungImageView.addSubview(self.imageView)
        self.addSubview(self.deviceNameLabel)
        self.addSubview(self.deviceTypeLabel)
        self.addSubview(self.optionsButton)
        self.backgroundColor = .clear

        self.backgroungImageView.snp.makeConstraints { make in
            make.size.equalTo(54)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(30)
        }

        self.imageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }

        self.deviceNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.backgroungImageView.snp.top)
            make.leading.equalTo(self.backgroungImageView.snp.trailing).offset(21)
        }

        self.deviceTypeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.backgroungImageView.snp.bottom)
            make.leading.equalTo(self.backgroungImageView.snp.trailing).offset(21)
            
        }

        self.optionsButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(36)
        }
    }

    private func apply(configuration: OtherDevicesContentConfiguration) {

        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration

        self.deviceNameLabel.text = configuration.deviceName
        self.deviceNameLabel.textColor = configuration.deviceNameColor
        self.deviceTypeLabel.text = configuration.deviceType
        self.deviceTypeLabel.textColor = configuration.deviceNameColor
        self.imageView.image = configuration.deviceImage
    }
}
