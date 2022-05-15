//
//  OtherDetailsInfoPresenter.swift
//  PDP
//
//  Created by Евгений Самарин on 12.05.2022.
//  
//

import Foundation

class OtherDetailsInfoPresenter: OtherDetailsInfoPresenterProtocol {

    // MARK: Properties

    weak var view: OtherDetailsInfoViewProtocol!
    var interactor: OtherDetailsInfoInteractorProtocol!
    var router: OtherDetailsInfoRouterProtocol!

    // MARK: - Initializer

    required init(view: OtherDetailsInfoViewProtocol) {
        self.view = view
    }

    func addButtonTapped() {
        debugPrint(#function, Self.self)
    }
    
    func deleteButtonTapped() {
        debugPrint(#function, Self.self)
        self.router.dismissViewController()
    }
}
