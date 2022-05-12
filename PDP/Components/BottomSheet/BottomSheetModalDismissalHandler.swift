//
//  BottomSheetModalDismissalHandler.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//

import Foundation

public protocol BottomSheetModalDismissalHandler {
    var canBeDismissed: Bool { get }

    func performDismissal(animated: Bool)
}
