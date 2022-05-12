//
//  MapPresenter.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//  
//

import Foundation

final class MapPresenter: MapPresenterProtocol {

    // MARK: Properties
    weak var view: MapViewProtocol!
    var interactor: MapInteractorProtocol!
    var router: MapRouterProtocol!

    // MARK: - Initializer

    required init(view: MapViewProtocol) {
        self.view = view
    }

    func configureView() {
    }
}
