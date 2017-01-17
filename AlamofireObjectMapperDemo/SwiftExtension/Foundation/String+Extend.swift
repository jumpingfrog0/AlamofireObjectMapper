//
//  String+Extend.swift
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

import Foundation
import UIKit

// MARK: - Format

extension String {
    
    /// Convert the specified format string to Date
    ///
    /// - Parameter format: Format (including number of components) of the attribute
    /// - Returns: A date representation of string interpreted using the receiver’s current settings. If date(fromFormat:) can not parse the string, returns nil.
    func date(fromFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    /// Convert a string to `Float`
    var toFloat: Float {
        return (self as NSString).floatValue
    }
    
    /// Convert a string to `Int`
    var toInt: Int {
        return (self as NSString).integerValue
    }
    
    
    /// Convert a string to `Double`
    var toDouble: Double {
        return (self as NSString).doubleValue
    }
    
    
    /// The length of elements in the string.
    var length: Int {
        return self.characters.count
    }
}

// MARK: - Substring

extension String: Collection {
    
    
    /// Returns a new string containing the characters of the String from the one at a given index to the end.
    func substring(fromIndex index: Int) -> String {
        return substring(from: characters.index(startIndex, offsetBy: index))
    }
    
    
    /// Returns a new string containing the characters of the String up to, but not including, the one at a given index.
    func substring(toIndex index: Int) -> String {
        return substring(to: characters.index(endIndex, offsetBy: index - length))
    }
    
    
    /// Returns a string object containing the characters of the String that lie within a given range.
    func substring(withRange range: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: range.lowerBound)
        let end = characters.index(startIndex, offsetBy: range.upperBound)
        return substring(with: start..<end)
    }
    
    /// Finds the String whether including Chinese characters or not. If not found, return `false`.
    var containsChineseCharacters: Bool {
        return range(of: "\\p{Han}", options: .regularExpression) != nil
    }
    
    /// Finds the String whether including a string matched a given regular expression or not. If not found, return `false`.
    func match(ofRegex regex: String) -> Bool {
        if let _ = range(of: regex, options: .regularExpression) {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Measurement

extension String {
    
    /// Calculates and returns the height for the receiver drawn using the given font, within the specified width in the current graphics context.
    ///
    /// - Parameters:
    ///   - constrainedWidth: the specified max width of the String.
    ///   - font: the font of the String.
    /// - Returns: The height for the receiver drawn.
    func height(constrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil)
        return boundingBox.height
    }
    
    /// Calculates and returns the height for the receiver drawn using the system font specified size, within the specified width in the current graphics context.
    ///
    /// - Parameters:
    ///   - constrainedWidth: the specified max width of the String.
    ///   - systemFontSize: The size (in points) to which the system font is scaled.
    /// - Returns: The height for the receiver drawn.
    func height(constrainedWidth width: CGFloat, systemFontSize size: CGFloat) -> CGFloat {
        return height(constrainedWidth: width, font: UIFont.systemFont(ofSize: size))
    }
    
    /// Calculates and returns the max width for the receiver drawn using the given font, within the greatest finite width in the current graphics context.
    ///
    /// - Parameters:
    ///   - font: the font of the String.
    /// - Returns: The max width for the receiver drawn.
    func maxWidth(font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil)
        return boundingBox.width
    }
    
    /// Calculates and returns the max width for the receiver drawn using the system font specified size, within the greatest finite width in the current graphics context.
    ///
    /// - Parameters:
    ///   - systemFontSize: The size (in points) to which the system font is scaled.
    /// - Returns: The max width for the receiver drawn.
    func maxWidth(systemFontSize size: CGFloat) -> CGFloat {
        return maxWidth(font: UIFont.systemFont(ofSize: size))
    }
}

// MARK: - NSAttributedString

extension NSAttributedString {
    
    /// Returns the height required to draw the string, within the specified width in the current graphics context.
    func height(constrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /// Returns the max width required to draw the string, within the greatest finite width in the current graphics context.
    func maxWidth() -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

// MARK: - NSMutableAttributedString

extension NSMutableAttributedString {
    
    /// Returns a text which is underlined of a given text.
    class func strikethrough(withText text: String?) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text ?? "")
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    class func strikethrough(withText text: String?, color: UIColor) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text ?? "")
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSStrikethroughColorAttributeName, value: color, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    class func underline(withText text: String?) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text ?? "")
        attributeString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    class func underline(withText text: String?, color: UIColor) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text ?? "")
        attributeString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSUnderlineColorAttributeName, value: color, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
