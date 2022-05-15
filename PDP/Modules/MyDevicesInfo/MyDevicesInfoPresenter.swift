//
//  MyDevicesInfoPresenter.swift
//  PDP
//
//  Created by Евгений Самарин on 15.05.2022.
//  
//

import Foundation

class MyDevicesInfoPresenter: MyDevicesInfoPresenterProtocol {

    // MARK: - Instance Properties

    weak var view: MyDevicesInfoViewProtocol!
    var interactor: MyDevicesInfoInteractorProtocol!
    var router: MyDevicesInfoRouterProtocol!

    // MARK: - Initializer

    required init(view: MyDevicesInfoViewProtocol) {
        self.view = view
    }
}
