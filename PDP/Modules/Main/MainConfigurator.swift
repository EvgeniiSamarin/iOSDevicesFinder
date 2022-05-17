//
//  MainConfigurator.swift
//  PDP
//
//  Created by Евгений Самарин on 20.02.2022.
//

import Foundation
import UIKit

final class MainConfigurator: MainConfiguratorProtocol {

    func configure() -> UIViewController {
        let viewController = MainViewController()
        let presenter = MainPresenter(view: viewController)
        let interactor = MainInteractor(presenter: presenter)
        let router = MainRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        return viewController
    }
}
