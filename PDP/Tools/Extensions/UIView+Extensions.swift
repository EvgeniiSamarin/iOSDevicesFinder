//
//  UIView+Extensions.swift
//  PDP
//
//  Created by Евгений Самарин on 5/17/22.
//

import UIKit

extension UIView {
     var leadingEdge: UIRectEdge {
         isRTL ? .right : .left
     }
     var trailingEdge: UIRectEdge {
         isRTL ? .left : .right
     }
     var isRTL: Bool {
         if #available(iOS 10.0, *) {
             return effectiveUserInterfaceLayoutDirection == .rightToLeft
         } else {
             return false
         }}
 }

extension FloatingPoint {
     func flipped(for view: UIView) -> Self {
         view.isRTL ? -self : self
     }
 }
