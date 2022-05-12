//
//  MapDetailInfoConfigurator.swift
//  PDP
//
//  Created by Евгений Самарин on 27.04.2022.
//

import Foundation
import UIKit

final class MapDetailInfoConfigurator: MapDetailInfoConfiguratorProtocol {

    func configure() -> UIViewController {
        let viewController = MapDetailInfoViewController(initialHeight: 300)
        let presenter = MapDetailInfoPresenter(view: viewController)
        let interactor = MapDetailInfoInteractor(presenter: presenter)
        let router = MapDetailInfoRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        return viewController
    }
}
