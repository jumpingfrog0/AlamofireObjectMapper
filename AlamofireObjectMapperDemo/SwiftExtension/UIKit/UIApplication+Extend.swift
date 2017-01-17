//
//  UIApplication+Extend.swift
//  SwiftExtension
//
//  Created by jumpingfrog0 on 01/12/2016.
//
//
//  Copyright (c) 2016 Jumpingfrog0 LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

extension UIApplication {
    
    
    /// Return the visible key window of application.
    /// This property can be using in `viewDidLoad` method.
    ///
    /// The view of root view controller is not appeared in the view hierarchy when `viewDidLoad` method calling, which result in key window being invisiable and nil, so should use the `.window` property of the `AppDelegate`.
    var visibleKeyWindow: UIWindow? {
        if let window = UIApplication.shared.keyWindow {
            return window
        } else {
            guard let window = UIApplication.shared.delegate?.window else {
                return nil
            }
            return window
        }
    }
    
    /// Returns the most top view controller excepts `UIAlertController`
    public func mostTopViewController() -> UIViewController {
        
        let topController = visibleKeyWindow?.rootViewController
        jf_assert(topController != nil, "The root view controller of keywindow is not existed.")
        return getTopController(topController)
    }
    
    private func getTopController(_ topController: UIViewController?) -> UIViewController {
        if topController is UINavigationController {
            
            guard let visibleViewController = (topController as! UINavigationController).visibleViewController else {
                
                return topController!
            }
            
            if visibleViewController is UIAlertController { // skip `UIAlertController`
                let topVc = topController as! UINavigationController
                let count = topVc.viewControllers.count
                return topVc.viewControllers[count - 1]
            }
            
            return visibleViewController
            
        } else if topController is UITabBarController {
            
            let tabBarController = topController as! UITabBarController
            
            if let selectedViewController = tabBarController.selectedViewController {
                
                return getTopController(selectedViewController)
            } else {
                return tabBarController.viewControllers![0]
            }
            
        } else { // UIViewController
            
            var topVc = topController
            while let presentedViewController = topVc?.presentedViewController {
                if presentedViewController is UIAlertController { // skip `UIAlertController`
                    break
                }
                topVc = presentedViewController
            }
            
            return topVc!
        }
    }
}

extension UIApplication {
    
    /// Check weather status bar appearance is under the control of view controller
    func jf_usesViewControllerBasedStatusBarAppearance() -> Bool {
        let key = "UIViewControllerBasedStatusBarAppearance"
        guard  let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            return true
        }
        
        return (object as! Bool)
    }
    
    /// Update status bar appearance.
    /// if status bar appearance is under the control of view controller, indicates to the system that the given view controller status bar attributes have changed.
    /// Otherwise, hides or shows the status bar, optionally animating the transition.
    func jf_updateStatusBarAppearanceHidden(_ hidden: Bool, animation: UIStatusBarAnimation, fromViewController controller: UIViewController) {
        
        if jf_usesViewControllerBasedStatusBarAppearance() {
            controller.setNeedsStatusBarAppearanceUpdate()
        } else {
            if #available(iOS 9, *) {
                
                debugPrint("setStatusBarHidden:withAnimation: is deprecated. Please use view-controller-based status bar appearance.")
                
            } else {
                UIApplication.shared.setStatusBarHidden(hidden, with: animation)
            }
        }
    }
}
