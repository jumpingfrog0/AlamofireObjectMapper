//
//  UIImage+Extend.swift
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
import QuartzCore

extension UIImage {
    
    /// Generate an image of a given text with a given size, a given background color and a given text color.
    ///
    /// - Parameters:
    ///   - text: The text to draw in.
    ///   - size: The size of image.
    ///   - backgroudColor: The background color of image.
    ///   - textColor: The text color to draw in.
    /// - Returns: A drawing image.
    class func image(text: String, size: CGSize, backgroudColor: UIColor = UIColor.white, textColor: UIColor = UIColor.black) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        backgroudColor.set()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.textColor = textColor
        label.textAlignment = .center
        label.text = text
        label.drawText(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /// Create an image of a given text including a triangle marker, with a given size, a given background color and a given text color.
    ///
    /// - Parameters:
    ///   - text: The text to draw in.
    ///   - size: The size of image.
    ///   - backgroudColor: The background color of image.
    ///   - textColor: The text color to draw in.
    /// - Returns: A drawing image including a triangle marker.
    class func markerImage(text: String, size: CGSize, backgroudColor: UIColor = UIColor.black, textColor: UIColor = UIColor.white) -> UIImage {
        let triangleWith = CGFloat(14)
        let drawingSize = CGSize(width: size.width, height: size.height + triangleWith / 2)
        
        // draw title
        UIGraphicsBeginImageContextWithOptions(drawingSize, false, 0.0)
        backgroudColor.set()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.textColor = textColor
        label.textAlignment = .center
        label.text = text
        label.drawText(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // draw a transparent layer
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.addRect(CGRect(x: 0, y: size.height, width: size.width, height: triangleWith / 2))
        UIColor.clear.set()
        ctx?.fillPath()
        
        // draw a triangle
        backgroudColor.set()
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: (size.width - triangleWith) / 2.0, y: size.height))
        path.addLine(to: CGPoint(x: size.width / 2.0, y: size.height + triangleWith / 2.0))
        path.addLine(to: CGPoint(x: (size.width + triangleWith) / 2.0, y: size.height))
        path.closeSubpath()
        
        ctx?.addPath(path)
        ctx?.fillPath()
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /// Returns an image that can be stretched arbitrarily and not deformed.
    class func resizableImage(named imageName: String) -> UIImage? {
        guard let normal = UIImage(named: imageName) else {
            jf_assert(false, "The image named `\(imageName)` not found.")
            return nil
        }
        let w = normal.size.width * 0.5
        let h = normal.size.height * 0.5
        return normal.resizableImage(withCapInsets: UIEdgeInsetsMake(h, w, h, w), resizingMode: .stretch)
    }
    
    
    /// Capture the image of a given view.
    class func captureView(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let clipImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return clipImage
    }
    
    /// Crops the image with a given rectangle.
    func cropping(to rect: CGRect) -> UIImage {
        let scale = max(self.scale, 1.0)
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        let imageRef = self.cgImage?.cropping(to: scaledRect)
        let croppingImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImageOrientation.up)
        return croppingImage
    }
}
