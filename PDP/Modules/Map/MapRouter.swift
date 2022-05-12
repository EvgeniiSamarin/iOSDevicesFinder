//
//  MapRouter.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//  
//

import Foundation
import UIKit

final class MapRouter: MapRouterProtocol {

    // MARK: - Instance Properties

    weak var viewController: MapViewController!

    // MARK: - Initializer

    init(viewController: MapViewController) {
        self.viewController = viewController
    }

    // TODO: - Route to another screen
}
