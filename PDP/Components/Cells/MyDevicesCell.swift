//
//  MyDevicesCell.swift
//  PDP
//
//  Created by Евгений Самарин on 20.03.2022.
//

import UIKit

final class MyDevicesCell: UICollectionViewCell {

    // MARK: - Instance Properties

    private lazy var deviceName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(ofSize: 22, forTextStyle: .body, forType: .semibold)
        return label
    }()

    private lazy var companyDeviceLogo: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var deviceLogo: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BackgroundMyDevice")
        return imageView
    }()
    private var isAnimate: Bool = false

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.layer.cornerRadius = 25
    }

    // MARK: -

    private func setupLayout() {
        self.contentView.addSubview(self.backgroundImageView)
        self.backgroundImageView.addSubview(self.deviceName)
        self.backgroundImageView.addSubview(self.companyDeviceLogo)
        self.backgroundImageView.addSubview(self.deviceLogo)

        self.backgroundImageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }

        self.deviceName.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(self.deviceLogo.snp.leading).offset(10)
            make.top.equalToSuperview().offset(15)
        }

        self.companyDeviceLogo.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(15)
        }

        self.deviceLogo.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().inset(30)
            
        }
    }

    @discardableResult
    func updated(with deviceImage: UIImage, deviceCompanyImage: UIImage, deviceName: String) -> Self {
        self.deviceLogo.image = deviceImage
        self.companyDeviceLogo.image = deviceCompanyImage
        self.deviceName.text = deviceName
        return self
    }

    func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 99999
        
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"animate")
//        removeBtn.isHidden = false
        isAnimate = true
    }

    func stopAnimate() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "animate")
//        self.removeBtn.isHidden = true
        isAnimate = false
    }
}
