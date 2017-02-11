//  FooBar.swift
//  AlamofireObjectMapperDemo
//
//  Created by jumpingfrog0 on 20/01/2017.
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
import RealmSwift

public enum FooEnum: Int {
    case foo0 = 0
    case foo1 = 1
    case foo2 = 2
}

enum OptionEnum<Value: RawRepresentable> {
    case Some(Value)
    case None
}

public protocol EnumBox: RawRepresentable {
    var rawValue: RawValue { get set }
}

public class FooEnumBox: Object, EnumBox {
    
    public typealias RawValue = Int
    typealias EnumType = FooEnum
    private let noneValue = 0
    
    public var rawValue: RawValue {
        get {
            switch _rawValue {
            case .Some(let value):
                return value.rawValue
            default:
                return noneValue
            }
        }
        set {
            if let value = EnumType(rawValue: newValue) {
                _rawValue = OptionEnum.Some(value)
            } else {
                _rawValue = OptionEnum.None
            }
        }
    }
    
    public required convenience init(rawValue: RawValue) {
        self.init()
        self.rawValue = rawValue
    }
    
    public convenience init(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }
    
    private var _rawValue: OptionEnum<EnumType> = OptionEnum.None
}

public class FooEnumBox2: Object, EnumBox {
    
    public typealias RawValue = Int
    typealias EnumType = FooEnum
    private let noneValue = 0
    
    public var rawValue: RawValue {
        get {
            switch _rawValue {
            case .Some(let value):
                return value.rawValue
            default:
                return noneValue
            }
        }
        set {
            if let value = EnumType(rawValue: newValue) {
                _rawValue = OptionEnum.Some(value)
            } else {
                _rawValue = OptionEnum.None
            }
        }
    }
    
    public required convenience init(rawValue: RawValue) {
        self.init()
        self.rawValue = rawValue
    }
    
    public convenience init(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }
    
    private var _rawValue: OptionEnum<EnumType> = OptionEnum.None
}

struct BarStruct {
    var bar: String = ""
}

class FooBar: Object, Mappable {
    dynamic var id: String = ""
    dynamic var foo: Foo?
    dynamic var bar: Bar?
    let foos = List<RealmStringObject>()
    let bars = List<RealmIntObject>()
    
    private dynamic var fooEnumRaw = 0
    var fooEnum: FooEnum {
        return FooEnum(rawValue: fooEnumRaw) ?? .foo0
    }
    let fooEnums = List<FooEnumBox>()
    let fooEnums2 = List<FooEnumBox2>()
    
    var barStruct: BarStruct?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        foo <- map["foo"]
        bar <- map["bar"]
        fooEnumRaw <- map["fooEnum"]
        barStruct <- map["barStruct"]
        
        var foos: [String]? = nil
        foos <- map["foos"]
        foos?.forEach({ (item) in
            let value = RealmStringObject()
            value.value = item
            self.foos.append(value)
        })
        
        var bars: [Int]? = nil
        bars <- map["bars"]
        bars?.forEach({ (item) in
            let value = RealmIntObject()
            value.value = item
            self.bars.append(value)
        })
        
        var enums: [Int]? = nil
        enums <- map["fooEnums"]
        enums?.forEach({ (item) in
            let value = FooEnumBox()
            value.rawValue = item
            self.fooEnums.append(value)
        })
        
        var enums2: [Int]? = nil
        enums2 <- map["fooEnums2"]
        enums2?.forEach({ (item) in
            let value = FooEnumBox2()
            value.rawValue = item
            self.fooEnums2.append(value)
        })
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
