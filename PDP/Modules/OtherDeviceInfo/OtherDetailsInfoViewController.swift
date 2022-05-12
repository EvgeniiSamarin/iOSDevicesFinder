//
//  OtherDetailsInfoViewController.swift
//  PDP
//
//  Created by Евгений Самарин on 12.05.2022.
//  
//

import UIKit
import SwiftUI

class OtherDetailsInfoViewController: UIViewController, OtherDetailsInfoViewProtocol {

    // MARK: - Nested Types

    enum Constants {
        static let addButton = "Добавить устройство"
        static let deleteButton = "Забыть устройство"
    }

    // MARK: - Instance Properties

    private lazy var addButton: Button = {
        let button = Button()
        button.setTitle(Constants.addButton, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()

    private lazy var cancelButton: Button = {
        let button = Button()
        button.setTitle(Constants.deleteButton, for: .normal)
        button.setTitleColor(.lightPurple, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 18
        button.layer.borderColor = UIColor.lightPurple.cgColor
        button.layer.borderWidth = 1
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 50
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        return stackView
    }()

    private var currentHeight: CGFloat {
        didSet {
            self.updatePreferredContentSize()
        }
    }

    var presenter: OtherDetailsInfoPresenterProtocol!

    // MARK: - Initializer

    init(initialHeight: CGFloat) {
        self.currentHeight = initialHeight
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.currentHeight = 300
        super.init(coder: coder)
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.updatePreferredContentSize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setNeedsLayout()
    }

    // MARK: - Instance Methods

    private func updatePreferredContentSize() {
        print("preferredContentHeight = \(self.stackView.layer.frame)")
        preferredContentSize = self.stackView.intrinsicContentSize
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 270)
    }

    private func setupUI() {
        self.stackView.addArrangedSubview(self.addButton)
        self.stackView.addArrangedSubview(self.cancelButton)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)

        self.stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(50)
        }

        self.addButton.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.trailing.leading.equalToSuperview().inset(30)
        }

        self.cancelButton.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.trailing.leading.equalToSuperview().inset(30)
        }

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.addButton.bounds
        gradient.colors = [UIColor.firstGradientButtonColor, UIColor.secondGradientButtonColor].map { $0.cgColor }
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.75)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.02, b: 0, c: 0, d: 20.64,
                                                                                tx: -0.02,
                                                                                ty: -9.66))
        gradient.bounds = view.bounds.insetBy(dx: -0.5 * self.addButton.bounds.size.width,
                                              dy: -0.5 * self.addButton.bounds.size.height)
        gradient.position = view.center
        self.addButton.layer.insertSublayer(gradient, at: 0)

        self.view.backgroundColor = OtherDetailsInfoAppearance.backgroundColor
    }
}
