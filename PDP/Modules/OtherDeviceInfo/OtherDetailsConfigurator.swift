//
//  OtherDetailsConfigurator.swift
//  PDP
//
//  Created by Евгений Самарин on 12.05.2022.
//

import Foundation
import UIKit

final class OtherDetailsConfigurator: OtherDetailsInfoConfiguratorProtocol {

    func configure(with initialHeight: CGFloat) -> UIViewController {
        let viewController = OtherDetailsInfoViewController(initialHeight: initialHeight)
        let presenter = OtherDetailsInfoPresenter(view: viewController)
        let interactor = OtherDetailsInfoInteractor(presenter: presenter)
        let router = OtherDetailsInfoRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        return viewController
    }
}

