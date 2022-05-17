//
//  BaseRouter.swift
//  PDP
//
//  Created by Евгений Самарин on 5/17/22.
//

import UIKit

final class ViewController: LiquidSwipeContainerController, LiquidSwipeContainerDataSource {
    
    var liquidControllers: [UIViewController] = {
        let firstPageVC = MainConfigurator().configure()
        let secondPageVC = MapConfigurator().configure()
        var controllers: [UIViewController] = [firstPageVC, secondPageVC]
        return controllers
    }()
    
    override func viewDidLoad() {
        // Uncomment for testing RTL
//        view.semanticContentAttribute = .forceRightToLeft
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.largeTitleDisplayMode = .never
        datasource = self
    }

    func numberOfControllersInLiquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController) -> Int {
        return liquidControllers.count
    }
    
    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, viewControllerAtIndex index: Int) -> UIViewController {
        return liquidControllers[index]
    }

}
