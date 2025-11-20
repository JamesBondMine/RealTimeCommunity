//
//  UIFont+Extension.swift
//  CIMKit
//
//  Created by cusPro on 2024/4/1.
//

import UIKit
extension UIFont {
    
    @MainActor
    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat.isSmallScreen ? size - 1 : size, weight: .medium)
    }
    
    @MainActor
    static func regular(_ size: CGFloat) -> UIFont  {
        return UIFont.systemFont(ofSize: CGFloat.isSmallScreen ? size - 1 : size, weight: .regular)
    }
    
    @MainActor
    static func semibold(_ size: CGFloat) -> UIFont  {
        return UIFont.systemFont(ofSize: CGFloat.isSmallScreen ? size - 1 : size, weight: .semibold)
    }
    
    @MainActor
    static func light(_ size: CGFloat) -> UIFont  {
        return UIFont.systemFont(ofSize: CGFloat.isSmallScreen ? size - 1 : size, weight: .light)
    }
    
}
