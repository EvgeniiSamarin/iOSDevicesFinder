//
//  MapConfigurator.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//

import Foundation
import UIKit

final class MapConfigurator: MapConfiguratorProtocol {

    func configure() -> UIViewController {
        let viewController = MapViewController()
        let presenter = MapPresenter(view: viewController)
        let interactor = MapInteractor(presenter: presenter)
        let router = MapRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        return viewController
    }
}
