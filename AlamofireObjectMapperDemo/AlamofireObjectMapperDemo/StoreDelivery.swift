//
//  StoreDelivery.swift
//  dinner517
//
//  Created by sheldon on 16/1/16.
//  Copyright © 2016年 anglesoft. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

enum DeliveryMethod: Int {
    case deliveryBy517 = 0
    case pickup = 1
    case deliveryByStore = 3
    
    func toString() -> String {
        switch self {
        case .deliveryBy517:
            return "DeliveryMethod"
        case .pickup:
            return "Pick up"
        case .deliveryByStore:
            return "DeliveryMethod"
        }
    }
}

class DeliveryMethodBox: Object, EnumBox {
    public typealias RawValue = Int
    typealias EnumType = DeliveryMethod
    private let noneValue = -1
    
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

class StoreDelivery: Object, Mappable {
    
    var minimum = RealmOptional<Double>()
    var time = RealmOptional<Int>()
    var feeFactor = RealmOptional<Double>()
    var flatFactor = RealmOptional<Double>()
    var distance = RealmOptional<Double>()
    let methods = List<DeliveryMethodBox>()
    var serviceFlatFactor = RealmOptional<Double>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        minimum <- (map["minimum"], NumericTransform<Double>())
        time <- (map["time"], NumericTransform<Int>())
        feeFactor <- (map["feeFactor"], NumericTransform<Double>())
        flatFactor <- (map["flatFactor"], NumericTransform<Double>())
        distance <- (map["distance"], NumericTransform<Double>())
        serviceFlatFactor <- (map["serviceFlatFactor"], NumericTransform<Double>())
        
        var enums: [Int]? = nil
        enums <- map["method"]
        enums?.forEach({ (item) in
            let value = DeliveryMethodBox()
            value.rawValue = item
            self.methods.append(value)
        })
    }
}
