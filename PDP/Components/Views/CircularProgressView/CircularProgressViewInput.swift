//
//  CircularProgressViewInput.swift
//  PDP
//
//  Created by Евгений Самарин on 15.05.2022.
//

import UIKit

protocol CircularProgressViewInput {

    // MARK: - Instance Properties

    var progress: CGFloat { get set }
    var lineWidth: CGFloat? { get set }
    var offset: CGFloat? { get set }
    var isEmptyState: Bool? { get set }
}
