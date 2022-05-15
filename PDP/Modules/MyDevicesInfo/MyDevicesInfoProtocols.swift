//
//  MyDevicesInfoProtocols.swift
//  PDP
//
//  Created by Евгений Самарин on 15.05.2022.
//  
//


import UIKit

protocol MyDevicesInfoViewProtocol: AnyObject {
   
}

protocol MyDevicesInfoPresenterProtocol: AnyObject {
}

protocol MyDevicesInfoInteractorProtocol: AnyObject {
}

protocol MyDevicesInfoRouterProtocol: AnyObject {
    
}

protocol MyDevicesInfoConfiguratorProtocol: AnyObject {
    func configure() -> UIViewController
}
