//
//  MyDevicesInfoInteractor.swift
//  PDP
//
//  Created by Евгений Самарин on 15.05.2022.
//  
//

import Foundation

class MyDevicesInfoInteractor: MyDevicesInfoInteractorProtocol {

    // MARK: - Instance Properties

    weak var presenter: MyDevicesInfoPresenterProtocol!

    // MARK: - Initializer

    init(presenter: MyDevicesInfoPresenterProtocol) {
        self.presenter = presenter
    }
}
