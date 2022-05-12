//
//  MapDetailInfoPresenter.swift
//  PDP
//
//  Created by Евгений Самарин on 27.04.2022.
//  
//

import Foundation

class MapDetailInfoPresenter: MapDetailInfoPresenterProtocol {

    // MARK: Properties
    weak var view: MapDetailInfoViewProtocol!
    var interactor: MapDetailInfoInteractorProtocol!
    var router: MapDetailInfoRouterProtocol!

    // MARK: - Initializer

    required init(view: MapDetailInfoViewProtocol) {
        self.view = view
    }

    func configureView() {
    }
}
