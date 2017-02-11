//  Goods.swift
//  AlamofireObjectMapperDemo
//
//  Created by jumpingfrog0 on 19/01/2017.
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

//enum PaymentMethod: Int {
//    case cash = 0
//    case creditCard = 1
//    
//    func toString() -> String {
//        switch self {
//        case .cash:
//            return "Cash"
//        case .creditCard:
//            return "Card"
//        }
//    }
//}

class Goods: Object, Mappable {
    
    dynamic var name: String = ""
    dynamic var price: Int = 0
    
    private dynamic var stateRaw = 0
//    var state: PaymentMethod {
//        return PaymentMethod(rawValue: stateRaw) ?? .cash
//    }
//    var states: List<PaymentMethod>?
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        price <- map["price"]
        stateRaw <- map["state"]
    }
    
    convenience init(name: String, price: Int) {
        self.init()
        self.name = name
        self.price = price
    }
}
