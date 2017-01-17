//  UIButton+Extend.swift
//  SwiftExtension
//
//  Created by jumpingfrog0 on 29/12/2016.
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

// MARK: - Submit

extension UIButton {
    
    fileprivate struct AssociatedKeys {
        static var submitting = "jf_submitting"
        static var modalView = "jf_modalView"
        static var indicatorView = "jf_indicatorView"
        static var spinnerTitleLabel = "jf_spinnerTitleLabel"
    }
    
    fileprivate var modalView: UIView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.modalView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.modalView) as? UIView
        }
    }
    
    fileprivate var indicatorView: UIActivityIndicatorView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.indicatorView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.indicatorView) as? UIActivityIndicatorView
        }
    }
    
    fileprivate var spinnerTitleLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.spinnerTitleLabel, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.spinnerTitleLabel) as? UILabel
        }
    }
    
    var isSubmitting: Bool? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.submitting, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.submitting) as? Bool
        }
    }
    
    func beginSubmitting(title: String) {
        endSubmitting()
        
        isSubmitting = true
        isHidden = true
        
        modalView = UIView(frame: frame)
        modalView?.backgroundColor = backgroundColor?.withAlphaComponent(0.6)
        modalView?.layer.cornerRadius = layer.cornerRadius
        modalView?.layer.borderWidth = layer.borderWidth
        modalView?.layer.borderColor = layer.borderColor
        
        let viewBounds = modalView!.bounds
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicatorView?.tintColor = spinnerTitleLabel?.textColor
        let indicatorBounds = indicatorView!.bounds
        indicatorView?.frame = CGRect(x: 10, y: viewBounds.size.height / 2 - indicatorBounds.size.height / 2, width: indicatorBounds.size.width, height: indicatorBounds.size.height)
        
        spinnerTitleLabel = UILabel(frame: viewBounds)
        spinnerTitleLabel?.textAlignment = .center
        spinnerTitleLabel?.text = title
        spinnerTitleLabel?.font = titleLabel?.font
        spinnerTitleLabel?.textColor = titleLabel?.textColor
        
        modalView?.addSubview(indicatorView!)
        modalView?.addSubview(spinnerTitleLabel!)
        superview?.addSubview(modalView!)
        
        indicatorView?.startAnimating()
    }
    
    func changeSubmittingTitle(_ title: String) {
        spinnerTitleLabel?.text = title
    }
    
    func endSubmitting() {
        guard let _ = isSubmitting else {
            return
        }
        
        isSubmitting = false
        isHidden = false
        
        modalView?.removeFromSuperview()
        modalView = nil
        indicatorView = nil
        spinnerTitleLabel = nil
    }
}


