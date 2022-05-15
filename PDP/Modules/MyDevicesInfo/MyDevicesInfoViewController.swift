//
//  MyDevicesInfoViewController.swift
//  PDP
//
//  Created by Евгений Самарин on 15.05.2022.
//  
//

import UIKit

class MyDevicesInfoViewController: UIViewController, MyDevicesInfoViewProtocol {

    // MARK: - Nested Types

    enum Constants {
        static let notifyLabelText = "Уведомить о потере"
        static let addressLabeltext = "20 минут назад\nМосква, Петровка, дом 38"
        static let meterLabelText = "15\n метров"
    }

    // MARK: - Instance Properties

    private lazy var meterLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.meterLabelText
        label.textColor = .primaryWhite
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .font(ofSize: 16, forTextStyle: .body, forType: .bold)
        return label
    }()

    private lazy var circularProgressView: CircularProgressView = {
        let circularProgressView = CircularProgressView()
        circularProgressView.clipsToBounds = true
        return circularProgressView
    }()

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.addressLabeltext
        label.textColor = .primaryWhite
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .font(ofSize: 14, forTextStyle: .body, forType: .regular)
        return label
    }()

    private lazy var batteryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .batteryIcon
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var batteryFillLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()

    private lazy var notifyLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.notifyLabelText
        label.textColor = .primaryWhite
        label.font = .font(ofSize: 18, forTextStyle: .body, forType: .semibold)
        return label
    }()

    private lazy var notifySwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.tintColor = MyDevicesInfoAppearance.backgroundColor
        switcher.onTintColor = .primaryWhite
        switcher.thumbTintColor = UIColor.lightPurple
        switcher.layer.borderWidth = 1
        switcher.layer.borderColor = UIColor.primaryWhite.cgColor
        switcher.layer.cornerRadius = switcher.frame.height / 2
        return switcher
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 50
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var notifyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()

    var presenter: MyDevicesInfoPresenterProtocol!

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.backButtonTitle = ""
        self.title = "Apple Watch"
    }

    private func setupUI() {
        self.stackView.addArrangedSubview(self.circularProgressView)
        self.circularProgressView.addSubview(self.meterLabel)
        self.stackView.addArrangedSubview(self.addressLabel)
        self.stackView.addArrangedSubview(self.batteryImage)
        self.stackView.addArrangedSubview(self.notifyStackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.notifyStackView.addArrangedSubview(self.notifyLabel)
        self.notifyStackView.addArrangedSubview(self.notifySwitcher)
        self.view.addSubview(stackView)

        self.stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(50)
        }

        self.notifyStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
        }

        self.circularProgressView.snp.makeConstraints { make in
            make.size.equalTo(210)
        }
        self.circularProgressView.lineWidth = 10
        self.circularProgressView.offset = 7
        self.circularProgressView.progress = 80
        self.circularProgressView.layoutSubviews()

        self.meterLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        self.view.backgroundColor = MyDevicesInfoAppearance.backgroundColor
    }
}
