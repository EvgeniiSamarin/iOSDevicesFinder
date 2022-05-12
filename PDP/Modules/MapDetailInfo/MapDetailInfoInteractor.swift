//
//  MapDetailInfoInteractor.swift
//  PDP
//
//  Created by Евгений Самарин on 27.04.2022.
//  
//

import Foundation

final class MapDetailInfoInteractor: MapDetailInfoInteractorProtocol {

    // MARK: - Instance Properties

    weak var presenter: MapDetailInfoPresenterProtocol!

    // MARK: - Initializer

    init(presenter: MapDetailInfoPresenterProtocol) {
        self.presenter = presenter
    }
}
