//
//  MainRouter.swift
//  PDP
//
//  Created by Евгений Самарин on 20.02.2022.
//

import UIKit

final class MainRouter: MainRouterProtocol {

    // MARK: - Instance Properties

    weak var viewController: MainViewController!
    private var transitionDelegate: UIViewControllerTransitioningDelegate?
//    var viewControllers: [UIViewController] = {
////        let firstPageVC = viewController
//        let secondPageVC = MapConfigurator().configure()
//        var controllers: [UIViewController] = [secondPageVC]
//        return controllers
//    }()

    // MARK: - Initializer

    init(viewController: MainViewController) {
//        viewController.datasource = self
        self.viewController = viewController
    }

    // TODO: - Route to another screen

    func showBottomSheetDeviceMenu(with device: DevicePreview) {
        let vc = OtherDetailsConfigurator().configure(with: 400)
        let navController = BottomSheetNavigationController(rootViewController: vc)
        transitionDelegate = BottomSheetTransitioningDelegate(presentationControllerFactory: self)
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = transitionDelegate
        self.viewController.navigationController?.present(navController, animated: true)
//        self.present(navController, animated: true)
    }

    func showMyDeviceDetailsInfo() {
        let vc = MyDevicesInfoConfigurator().configure()
        self.viewController.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - BottomSheetPresentationControllerFactory

extension MainRouter: BottomSheetPresentationControllerFactory {

    func makeBottomSheetPresentationController(
            presentedViewController: UIViewController,
            presentingViewController: UIViewController?
        ) -> BottomSheetPresentationController {
            .init(
                presentedViewController: presentedViewController,
                presentingViewController: presentingViewController,
                dismissalHandler: self
            )
        }
}

// MARK: - BottomSheetModalDismissalHandler

extension MainRouter: BottomSheetModalDismissalHandler {
    var canBeDismissed: Bool { true }

    func performDismissal(animated: Bool) {
        self.viewController.presentedViewController?.dismiss(animated: animated, completion: nil)
        transitionDelegate = nil
    }
}
//
//extension MainRouter: LiquidSwipeContainerDataSource {
//    func numberOfControllersInLiquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController) -> Int {
//        self.viewControllers.count
//    }
//    
//    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, viewControllerAtIndex index: Int) -> UIViewController {
//        self.viewControllers[index]
//    }
//}
//
//extension MainRouter: LiquidSwipeContainerDelegate {
//    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, willTransitionTo: UIViewController) {
//    }
//
//    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, didFinishTransitionTo: UIViewController, transitionCompleted: Bool) {
//    }
//}
