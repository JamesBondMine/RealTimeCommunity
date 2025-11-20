//
//  CGFloat+Extension.swift
//  CIMKit
//
//  Created by cusPro on 2024/4/1.
//

import Foundation
import UIKit

extension CGFloat {
    
    /// 屏幕宽
    @MainActor
    public static var width: CGFloat {
        UIScreen.main.bounds.width
    }
    
    /// 屏幕高
    @MainActor
    public static var height: CGFloat {
        UIScreen.main.bounds.height
    }
    
    /// 状态栏高度
    @MainActor
    public static var statusBar: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
            return window?.safeAreaInsets.top ?? 44
        } else if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.windows.first
            return window?.safeAreaInsets.top ?? 44
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    /// 导航条高度
    public static let naviHeight: CGFloat = 44
    
    /// 导航栏高度
    @MainActor
    public static var naviBar: CGFloat {
        naviHeight + statusBar
    }
    
    /// 底部安全区 高度
    @MainActor
    public static var safeBottom: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
            return window?.safeAreaInsets.bottom ?? 0
        } else if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.windows.first
            return window?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }
    
    /// 顶部安全区 高度
    @MainActor
    public static var safeTop: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
            return window?.safeAreaInsets.top ?? 0
        } else if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.windows.first
            return window?.safeAreaInsets.top ?? 0
        } else {
            return 0
        }
    }
    
    /// 刘海屏
    @MainActor
    public static var isIPhoneX: Bool {
        safeBottom > 0
    }
    
    /// 屏幕适配
    @MainActor
    public static func DWScale(_ value: CGFloat) -> CGFloat {
        return value / 375.0 * UIScreen.main.bounds.size.width
    }
    
    /// tabBar 高度
    @MainActor
    public static var tabBar: CGFloat {
        safeBottom + 49
    }
    
    ///小屏
    @MainActor
    public static var isSmallScreen: Bool {
        width <= 640
    }
    
}
