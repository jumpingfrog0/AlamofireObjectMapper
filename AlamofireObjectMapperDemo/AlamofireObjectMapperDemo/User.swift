//  User.swift
//  AlamofireObjectMapperDemo
//
//  Created by jumpingfrog0 on 11/01/2017.
//
//
//  Copyright (c) 2017 Jumpingfrog0 LLC
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
import ObjectMapper
import Realm
import RealmSwift

class User: Object, Mappable {
    
    dynamic var name: String?
    var age = RealmOptional<Int>()
    var goods: List<Goods> = List<Goods>()
//    var age: Int? // wrong, can't be persisted
//    var goods: [Goods]? // wrong, can't be persisted
//    var goods: List<Goods>()? // wrong, can't be persisted
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        age <- (map["age"], NumericTransform<Int>())
        goods <- (map["goods"], ListTransform<Goods>())
    }
    
    func save() -> Bool {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(self, update: true)
            }
            return true
        } catch {
            return false
        }
    }
}
