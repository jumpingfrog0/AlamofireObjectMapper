//
//  Array+Extend.swift
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

extension Array {
    
    
    /// Returns the first index where the specified object appears in the
    /// collection.
    ///
    /// After using `indexOfObject(object:)` to find the position of a particular object in
    /// a collection, you can use it to access the object by subscripting. This
    /// example shows how you can modify one of the names in an array of
    /// students.
    ///
    ///     var students = ["Ben", "Ivy", "Jordell", "Maxime"]
    ///     if let i = students.index(of: "Maxime") {
    ///         students[i] = "Max"
    ///     }
    ///     print(students)
    ///     // Prints "["Ben", "Ivy", "Jordell", "Max"]"
    ///
    /// - Parameter object: An object to search for in the collection.
    /// - Returns: The first index where `object` is found. If `object` is not
    ///   found in the collection, returns `nil`.
    ///
    /// - SeeAlso: In Swift 3.0, Apple has implemented `index(of:)` method to perform the same functionality, but only can be used in some types. e.g. `Int`, `Double`, 'Float`, `Bool` etc.
    func indexOfObject<T: Equatable>(_ object: T) -> Int?
    {
        var index: Int?
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? T {
                if object == to {
                    index = idx
                    break
                }
            }
        }
        
        return index
    }
    
    
    /// Returns all index where the specified object appears in the collection.
    ///
    /// - Parameter object: An object to search for in the collection.
    /// - Returns: All index where `object` is found. If `object` is not
    ///   found in the collection, returns `nil`.
    func indexesOfObject<T: Equatable>(_ object: T) -> [Int]? {
        var indexes = [Int]()
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? T {
                if object == to {
                    indexes.append(idx)
                }
            }
        }
        
        if indexes.count > 0 {
            return indexes
        } else {
            return nil
        }
    }
    
    
    /// Remove the specified object appears in the collection. Only remove one object.
    ///
    /// - Parameter object: An object to remove in the collection.
    /// - Returns: Whether remove successfully or not. If `object` is not found in the colleciton, return `false`.
    mutating func removeObject<T: Equatable>(_ object : T) -> Bool
    {
        if let index = self.indexOfObject(object) {
            self.remove(at: index)
            return true
        } else {
            return false
        }
    }
}
