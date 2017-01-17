//
//  Time+Extend.swift
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

public func getDateFormatter() -> DateFormatter{
    struct Singleton {
        static let formatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.locale = Locale.current
            return formatter
            }()
    }
    return Singleton.formatter
}

public enum TimestampPrecision {
    case second
    case millisecond
    case microsecond
}

extension Date {
    
    /// Format Date to string.
    ///
    /// - Parameter format: Format (including number of components) of the attribute
    /// - Returns: A String formatted.
    func toString(_ format: String) -> String {
        getDateFormatter().dateFormat = format
        return getDateFormatter().string(from: self)
    }
    
    /// Returns the first moment of a given TimeInterval, as a Date.
    ///
    /// - parameter timestamp: The timestamp of date that you want to calculate or convert
    /// - parameter precision: The precision of the timestamp you pass
    /// - returns: The first moment of the given timestamp.
    static func startOfDay(forTimestamp timestamp: TimeInterval, precision: TimestampPrecision = .second) -> Date {
        var date: Date!
        switch precision {
        case .microsecond:
            date = Date(timeIntervalSince1970: timestamp / 100_0000)
        case .millisecond:
            date = Date(timeIntervalSince1970: timestamp / 1000)
        case .second:
            date = Date(timeIntervalSince1970: timestamp)
        }
        
        return Calendar.current.startOfDay(for: date)
    }
    
    
    /// Returns the first moment of today, as a Date.
    static func startOfToday() -> Date {
       return Calendar.current.startOfDay(for: Date())
    }
}

extension TimeInterval {
    
    /// Convert precision of timestamp
    ///
    /// - Parameters:
    /// - from: The origin timestamp precision
    /// - to: The target timestamp precision
    /// - Returns: The timestamp converted.
    func convertPrecision(from: TimestampPrecision, to: TimestampPrecision) -> TimeInterval {
        switch (from, to) {
        case (.microsecond, .second):
            return Date(timeIntervalSince1970: self / 100_0000).timeIntervalSince1970
        case (.microsecond, .millisecond):
            return Date(timeIntervalSince1970: self / 1000).timeIntervalSince1970
        case (.millisecond, .second):
            return Date(timeIntervalSince1970: self / 1000).timeIntervalSince1970
        case (.second, .microsecond):
            return Date(timeIntervalSince1970: self * 100_0000).timeIntervalSince1970
        case (.second, .millisecond):
            return Date(timeIntervalSince1970: self * 1000).timeIntervalSince1970
        case (.millisecond, .microsecond):
            return Date(timeIntervalSince1970: self * 1000).timeIntervalSince1970
        default:
            jf_assert(false, "Convert failed. Invalid parameters.")
            return self
        }
    }
    
    /// Returns a `Date` initialized relative to 00:00:00 UTC on 1 January 1970 by `self` seconds.
    func date() -> Date {
        return Date(timeIntervalSince1970: self)
    }
}
