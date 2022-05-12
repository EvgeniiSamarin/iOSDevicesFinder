//
//  MapDetailInfoViewController.swift
//  PDP
//
//  Created by Евгений Самарин on 27.04.2022.
//  
//

import UIKit

class MapDetailInfoViewController: UIViewController, MapDetailInfoViewProtocol {

    // MARK: - Instance Properties

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var activityLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: -

    private var currentHeight: CGFloat {
        didSet {
            self.updatePreferredContentSize()
        }
    }

    var presenter: MapDetailInfoPresenterProtocol!

    // MARK: - Init

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
        self.presenter.configureView()
        self.setupView()
        self.mockData()
        self.updatePreferredContentSize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setNeedsLayout()
    }
}

extension MapDetailInfoViewController {

    // MARK: - Instance Methods

    private func setupView() {
        self.stackView.addArrangedSubview(self.locationLabel)
        self.stackView.addArrangedSubview(self.activityLabel)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)

        self.stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }

        self.locationLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(30)
        }

        self.activityLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(30)
        }

        self.view.backgroundColor = .red
    }

    private func updatePreferredContentSize() {
        print("preferredContentHeight = \(currentHeight)")
        preferredContentSize = self.stackView.intrinsicContentSize
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
    }
}

extension MapDetailInfoViewController {

    private func mockData() {
        self.locationLabel.text = "Москва, Петровка, дом 38"
        self.activityLabel.text = "Последняя активность: 20 мин назад"
    }
}
