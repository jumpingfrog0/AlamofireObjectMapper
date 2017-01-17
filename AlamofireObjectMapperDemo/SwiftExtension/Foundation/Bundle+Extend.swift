//
//  NSBundel+Extend.swift
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

import Foundation

extension Bundle {
    
    /* The human-readable name of the bundle. */
    var bundleName: String? {
        return self.object(forInfoDictionaryKey: String(kCFBundleNameKey)) as? String
    }
    
    /* The build number of the bundle. */
    var bundleBuildVersion: String? {
        return self.object(forInfoDictionaryKey: String(kCFBundleVersionKey)) as? String
    }
    
    /* The version number of the bundle */
    var bundleShortVersion: String? {
        return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    /* The name of the executable in this bundle */
    var bundleExecuteable: String? {
        return self.object(forInfoDictionaryKey: String(kCFBundleExecutableKey)) as? String
    }
}
