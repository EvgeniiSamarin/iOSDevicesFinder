//
//  MapDetailInfoProtocols.swift
//  PDP
//
//  Created by Евгений Самарин on 27.04.2022.
//  
//

import UIKit

protocol MapDetailInfoViewProtocol: AnyObject {
}

protocol MapDetailInfoPresenterProtocol: AnyObject {

    // MARK: - Protocol Methods

    func configureView()
}

protocol MapDetailInfoInteractorProtocol: AnyObject {

    // MARK: - Protocol Properties

    // MARK: - Protocol Method
}

protocol MapDetailInfoRouterProtocol: AnyObject {
    
}

protocol MapDetailInfoConfiguratorProtocol: AnyObject {
    func configure() -> UIViewController
}
