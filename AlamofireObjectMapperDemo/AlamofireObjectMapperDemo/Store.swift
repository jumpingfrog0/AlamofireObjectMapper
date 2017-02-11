//
//  Store.swift
//  dinner517
//
//  Created by sheldon on 16/1/16.
//  Copyright © 2016年 anglesoft. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Location: Object, Mappable {
    var latitude = RealmOptional<Double>()
    var longitude = RealmOptional<Double>()
    
    func mapping(map: Map) {
        latitude <- (map["latitude"], NumericTransform<Double>())
        longitude <- (map["longitude"], NumericTransform<Double>())
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
}

enum PaymentMethod: Int {
    case cash = 0
    case creditCard = 1
    
    func toString() -> String {
        switch self {
        case .cash:
            return "Cash"
        case .creditCard:
            return "Card"
        }
    }
}

class PaymentMethodBox: Object, EnumBox {
    public typealias RawValue = Int
    typealias EnumType = PaymentMethod
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

class Store: Object, Mappable {
    
    dynamic var storeId: String?
//    dynamic var cover: String?
//    var open = RealmOptional<Bool>()
//    let paymentMethods = List<PaymentMethodBox>()
//    dynamic var regionId: String?
//    dynamic var location: Location?
//    dynamic var delivery: StoreDelivery?
//    dynamic var information: StoreInformation?
    
//    var name: String {
////        switch I18NUtil.currentLanguage() {
////        case .CN:
////            return nameCn ?? ""
////        case .EN:
////            return nameEn ?? ""
////        }
//        return "xxxx"
//    }
    
    var nameEn: String?
    var nameCn: String?
    
    override static func primaryKey() -> String? {
        return "storeId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        storeId <- map["storeId"]
//        cover <- map["logo.web"]
//        open <- (map["open"], NumericTransform<Bool>())
//        
//        var enums: [Int]? = nil
//        enums <- map["paymentType"]
//        enums?.forEach({ (item) in
//            let value = PaymentMethodBox()
//            value.rawValue = item
//            self.paymentMethods.append(value)
//        })
//        
//        regionId <- map["regionId"]
//        location <- map["location"]
//        delivery <- map["delivery"]
////        information <- map["information"]
//        
        nameCn <- map["name"]
        nameEn <- map["nameEn"]
    }
    
//    func getDeliveryMethodsString() -> String {
//        
//        var string = ""
//        
//        guard let methods = delivery?.methods, methods.isEmpty == false else {
//            return string
//        }
//        
//        methodsLoop: for method in methods {
//            
//            let method = DeliveryMethod(rawValue: method.rawValue)
//            
//            switch method! {
//            case .deliveryBy517, .deliveryByStore:
//                string += method!.toString()
//                break methodsLoop
//            default: break
//            }
//        }
//        
//        methodsLoop: for method in methods {
//            
//            let method = DeliveryMethod(rawValue: method.rawValue)
//            
//            switch method! {
//            case .pickup:
//                if string != "" {
//                    string += "/"
//                }
//                string += method!.toString()
//                break methodsLoop
//            default: break
//            }
//        }
//        
//        return string
//    }
//    
    func getCurrentDayBusinessHour() -> String {
        
        return "43200"
    }
    
}

extension Store {
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
    
    func unsave() -> Bool {
        let realm = try! Realm()
        do {
            try realm.write {
                let object = realm.objects(Store.self)
                realm.delete(object)
            }
            return true
        } catch {
            return false
        }
    }
    
    func getFromDataBase() {
        
    }
    
    func isSaved() -> Bool {
        let realm = try! Realm()
        let store = realm.object(ofType: Store.self, forPrimaryKey: storeId)
        return (store == nil) ? false : true
    }
}
