//
//  MyDevicesInfoConfigurator.swift
//  PDP
//
//  Created by Евгений Самарин on 15.05.2022.
//

import UIKit

final class MyDevicesInfoConfigurator: MyDevicesInfoConfiguratorProtocol {

    func configure() -> UIViewController {
        let viewController = MyDevicesInfoViewController()
        let presenter = MyDevicesInfoPresenter(view: viewController)
        let interactor = MyDevicesInfoInteractor(presenter: presenter)
        let router = MyDevicesInfoRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        return viewController
    }
}
