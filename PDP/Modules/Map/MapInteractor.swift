//
//  MapInteractor.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//  
//

import Foundation

final class MapInteractor: MapInteractorProtocol {

    // MARK: - Instance Properties

    weak var presenter: MapPresenterProtocol!

    // MARK: - Initializer

    init(presenter: MapPresenterProtocol) {
        self.presenter = presenter
    }
}
