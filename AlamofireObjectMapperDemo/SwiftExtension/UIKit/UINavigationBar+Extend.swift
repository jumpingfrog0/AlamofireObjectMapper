//
//  UINavigationBar+Extend.swift
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

extension UINavigationBar {
    
    fileprivate struct AssociatedKeys {
        static var overlayKey = "jf_overlayKey"
    }
    
    /// A layer cover above `UINavigationBar`, using to change background color of navigation bar etc.
    fileprivate var overlay: UIView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.overlayKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.overlayKey) as? UIView
        }
    }
    
    /// Set background color of navigation bar.
    func jf_setBackgroundColor(_ backgroundColor: UIColor) {
        if overlay == nil {
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
            overlay = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.width, height: self.bounds.height + 20))
            overlay?.isUserInteractionEnabled = false
            overlay?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            insertSubview(overlay!, at: 0)
        }
        
        overlay?.backgroundColor = backgroundColor
    }
    
    /// Recover the origin style of navigation bar.
    func jf_reset() {
        self.setBackgroundImage(nil, for: .default)
        overlay?.removeFromSuperview()
        overlay = nil
    }
}
