//
//  OtherDetailsInfoInteractor.swift
//  PDP
//
//  Created by Евгений Самарин on 12.05.2022.
//  
//

import Foundation

class OtherDetailsInfoInteractor: OtherDetailsInfoInteractorProtocol {

    // MARK: - Instance Properties

    weak var presenter: OtherDetailsInfoPresenterProtocol!

    // MARK: - Initializer

    init(presenter: OtherDetailsInfoPresenterProtocol) {
        self.presenter = presenter
    }
}
