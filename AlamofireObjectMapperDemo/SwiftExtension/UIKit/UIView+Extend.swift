//
//  UIView+Extend.swift
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

// MARK: - Nib

extension UIView {
    
    /// Create the first instantiated view of a given nib file in the specified bundle
    class func load(fromNibName nibName: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibName,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil).first as? UIView
    }
    
    /// Create the first instantiated view of the nib file named as the same as its class name
    class func loadFromNib() -> UIView? {
        return UINib(nibName: entityName(), bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }
    
    /// Create the `index` instantiated view of the nib file named as the same as its class name
    class func loadFromNib(ofIndex index: Int) -> UIView? {
        var views = UINib(nibName: entityName(), bundle: nil).instantiate(withOwner: nil, options: nil) as? [UIView]
        return views?[index]
    }
    
    /// Returns the class name of view
    class func entityName() -> String {
        let classString = NSStringFromClass(self)
        // The entity is the last component of dot-separated class name
        let components = classString.split { $0 == "." }
        return components.last ?? classString
    }
}


// MARK: - Frame

extension UIView {
    
    /// The x-coordinate of the view's location
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// The y-coordinate of the view's location
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    /// The width value of the view's size.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    /// The height value of the view's size.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// The right coordinate of the view.
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            frame.origin.x = newValue - frame.size.width
        }
    }
    
    /// The bottom coordinate of the view.
    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            frame.origin.y = newValue - frame.size.height
        }
    }
    
    /// The x-coordinate of the view's center
    var midX: CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }
    
    /// The y-coordinate of the view's center
    var midY: CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }
}

// MARK: - XibConfiguration

extension UIView {
    
    /// The color of the view’s border. Animatable.
    @IBInspectable var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }
    
    /// The width of the view’s border. Animatable.
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    
    /// The radius to use when drawing rounded corners for the view’s background. Animatable.
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    /// A Boolean indicating whether subviews are clipped to the view’s bounds. Animatable.
    @IBInspectable var masksToBounds: Bool {
        set {
            self.layer.masksToBounds = newValue
        }
        get {
            return self.layer.masksToBounds
        }
    }
}

// MARK: - Other

extension UIView {
    
    /// Remove all subviews.
    func removeAllSubviews() {
        //        self.subviews.map { $0.removeFromSuperview() }
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    /// The view controller of this view embed.
    var embedViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

// MARK: - Mask

extension UIView {
    /// Set the view's border with a given corner radius, a given color and a given width.
    ///
    /// This method fixs up the glitch at border that you can see a thin black border line around. The code is bleow:
    ///
    ///     button.layer.borderWidth = 2.0;
    ///     button.layer.borderColor = [[UIColor whiteColor] CGColor];
    ///     button.layer.cornerRadius = 4;
    ///     button.clipsToBounds = YES;
    ///
    /// Refer to: http://stackoverflow.com/questions/25551053/cornerradius-with-border-some-glitch-at-border
    func setBorder(cornerRadius radius: CGFloat, color: UIColor, width: CGFloat) {
        let rect = bounds
        
        // Make round
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer
        
        // Give Border
        let borderPath = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: radius, height: radius))
        let borderLayer = CAShapeLayer()
        borderLayer.frame = rect
        borderLayer.path = borderPath.cgPath
        borderLayer.strokeColor = color.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = width
        
        // Add this layer to give border.
        self.layer.addSublayer(borderLayer)
    }
    
    /// Round only a subset of the corners of the rectangle.
    ///
    /// - Parameters:
    ///   - corners: The corners that you want rounded.
    ///   - radius: The radius of each corner oval. Values larger than half the rectangle’s width or height are clamped appropriately to half the width or height.
    func setRoundCorners(byRoundingCorners corners: UIRectCorner, radius: CGFloat) {
        let rect = bounds
        
        // Make round
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer
    }
    
    // TODO: Set Hollow
    
//    func setHollowWithCenterFrame(_ centerFrame: CGRect) {
//        let path = UIBezierPath(rect: self.frame)
//        path.append(UIBezierPath(rect: self.frame))
//        path.append(UIBezierPath(rect: centerFrame).reversing())
//        path.usesEvenOddFillRule = true
//        
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = path.cgPath
//        self.layer.mask = maskLayer
//    }
//    
//    func setHollowCircleWithCornerRadius(_ radius: CGFloat) {
//        
//        let rect = CGRect(x: self.center.x - radius, y: self.center.y - radius, width: radius * 2, height: radius * 2)
//        
//        let path = UIBezierPath()
//        path.append(UIBezierPath(rect: self.frame))
//        path.append(UIBezierPath(roundedRect: rect, cornerRadius: radius).reversing())
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = path.cgPath
//        self.layer.mask = maskLayer
//    }
}
