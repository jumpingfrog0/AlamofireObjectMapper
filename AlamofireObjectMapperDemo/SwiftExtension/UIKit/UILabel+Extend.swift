//
//  UILabel+Extend.swift
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

extension UILabel {
    
    
    /// Applies strikethrough attribute for the text displayed by the label.
    func strikethrough() {
        self.attributedText = NSMutableAttributedString.strikethrough(withText: self.text)
    }
    
    
    /// Applies strikethrough attribute for the text displayed by the label with a given color.
    func strikethrough(color: UIColor) {
        self.attributedText = NSMutableAttributedString.strikethrough(withText: self.text, color: color)
    }
    
    
    /// Applies underline attribute for the text displayed by the label.
    func underline() {
        self.attributedText = NSMutableAttributedString.underline(withText: self.text)
    }
    
    /// Applies underline attribute for the text displayed by the label with a given color.
    func underline(color: UIColor) {
        self.attributedText = NSMutableAttributedString.underline(withText: self.text, color: color)
    }
    
    
    /// Sets the color of charactors displayed by the label within a given range.
    func setTextColor(_ color: UIColor, range: NSRange) {
        let attributedText = NSMutableAttributedString(string: self.text ?? "")
        attributedText.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        self.attributedText = attributedText
    }
    
    
    /// Set charactors displayed by the label with different colors within some given ranges.
    ///
    /// - Parameters:
    ///   - colors: A array of different colors.
    ///   - ranges: A array of ranges that text colors applied for.
    func setTextColors(_ colors: [UIColor], ranges: [NSRange]) {
        
        let attributedText = NSMutableAttributedString(string: self.text ?? "")
        
        // Check that colors and ranges contain the same number of items.
        jf_assert(colors.count == ranges.count, "Colors and Ranges must contain the same number of items")
        
        for (idx, _) in colors.enumerated() {
            attributedText.addAttribute(NSForegroundColorAttributeName, value: colors[idx], range: ranges[idx])
        }
        
        self.attributedText = attributedText
    }
}
