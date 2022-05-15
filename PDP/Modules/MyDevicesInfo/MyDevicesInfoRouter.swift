//
//  MyDevicesInfoRouter.swift
//  PDP
//
//  Created by Евгений Самарин on 15.05.2022.
//  
//

import Foundation
import UIKit

class MyDevicesInfoRouter: MyDevicesInfoRouterProtocol {

    // MARK: - Instance Properties

    weak var viewController: MyDevicesInfoViewController!

    // MARK: - Initializer

    init(viewController: MyDevicesInfoViewController) {
        self.viewController = viewController
    }
}
