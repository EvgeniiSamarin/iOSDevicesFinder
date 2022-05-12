//
//  OtherDetailsInfoRouter.swift
//  PDP
//
//  Created by Евгений Самарин on 12.05.2022.
//  
//

import Foundation
import UIKit

class OtherDetailsInfoRouter: OtherDetailsInfoRouterProtocol {

    // MARK: - Instance Properties

    weak var viewController: OtherDetailsInfoViewController!

    // MARK: - Initializer

    init(viewController: OtherDetailsInfoViewController) {
        self.viewController = viewController
    }
}
