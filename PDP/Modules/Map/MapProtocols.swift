//
//  MapProtocols.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//  
//

import UIKit

protocol MapViewProtocol: AnyObject {
}

protocol MapPresenterProtocol: AnyObject {

    // MARK: - Protocol Methods

    func configureView()
}

protocol MapInteractorProtocol: AnyObject {

    // MARK: - Protocol Properties

    // MARK: - Protocol Method
}

protocol MapRouterProtocol: AnyObject {
    
}

protocol MapConfiguratorProtocol: AnyObject {
    func configure() -> UIViewController
}
