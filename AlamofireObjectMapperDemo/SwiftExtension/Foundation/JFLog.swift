//
//  LogMacros.swift
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


/// Writes the textual representations of the given items most suitable for
/// debugging into the standard output. Never perform in Release builds.
///
/// - Parameters:
///   - items: Zero or more items to print.
///   - file: The file name to print items. The default is the file where `jf_print(_:_:_:_:)` is called.
///   - function: The function name to print items. The default is the function where 
///     `jf_print(_:_:_:_:)` is called.
///   - line: The line number to print items. The default is the line number where `jf_print(_:_:_:_:)`
///     is called.
public func jf_print<T>(_ items: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
{
    #if DEBUG
        let now = Date().toString("yyyy-MM-dd HH:mm:ss:SSS")
        let bundleName = Bundle.main.bundleName
        let filename = file.split(separator: "/").last
        print("\(now) [\(bundleName!)] \(filename!)(\(line)) \(function) : \(items)")
    #endif
}


/// Performs a traditional C-style assert with an optional message.
///
/// Use this function for internal sanity checks that are active during testing
/// but do not impact performance of shipping code. Never perform in Release builds.
///
/// - Parameters:
///   - condition: The condition to test. `condition` is only evaluated in
///     playgrounds and `-Onone` builds.
///   - message: A string to print if `condition` is evaluated to `false`. The
///     default is an empty string.
///   - function: The function name to print with `message` if the assertion fails. The
///     default is the function where `jf_assert(_:_:_:file:line:)` is called.
///   - file: The file name to print with `message` if the assertion fails. The
///     default is the file where `jf_assert(_:_:_:file:line:)` is called.
///   - line: The line number to print along with `message` if the assertion
///     fails. The default is the line number where `jf_assert(_:_:_:file:line:)`
///     is called.
public func jf_assert(_ condition: @autoclosure () -> Bool, _ message: String = "", _ function: String = #function, file: String = #file, line: Int = #line) {
    #if DEBUG
        if !condition() {
            let now = Date().toString("yyyy-MM-dd HH:mm:ss:SSS")
            let bundleName = Bundle.main.bundleName
            let filename = file.split(separator: "/").last
            print("\(now) [\(bundleName!)] \(filename!)(\(line)) \(function) : [jf assertion failed] \(message)")
            abort()
        }
    #endif
}


/// Writes the textual representation of the given json most suitable for
/// debugging into the standard output. Never perform in Release builds.
///
/// - Parameter json: The json to output into string.
public func jf_printJSON(_ json: [String : AnyObject]) {
    do {
        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        let strJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        jf_print( "jf_printJson ---- " + "\(strJson)")
    } catch _ {
        
        jf_print(" jf_printJson ---- json can not be serialized, please check the formatter.")
    }
    
}
