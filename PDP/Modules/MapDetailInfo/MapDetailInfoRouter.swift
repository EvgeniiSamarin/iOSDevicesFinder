//
//  MapDetailInfoRouter.swift
//  PDP
//
//  Created by Евгений Самарин on 27.04.2022.
//  
//

import Foundation
import UIKit

final class MapDetailInfoRouter: MapDetailInfoRouterProtocol {

    // MARK: - Instance Properties

    weak var viewController: MapDetailInfoViewController!

    // MARK: - Initializer

    init(viewController: MapDetailInfoViewController) {
        self.viewController = viewController
    }

    // TODO: - Route to another screen
}

