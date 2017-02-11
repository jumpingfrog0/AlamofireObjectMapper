//
//  StoreInformation.swift
//  dinner517
//
//  Created by sheldon on 16/1/16.
//  Copyright © 2016年 anglesoft. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class BusinessHour: Object, Mappable {
    
    dynamic var start: Int = 0
    dynamic var end: Int = 0
    dynamic var day: Int = 0 // the day of the week, Monday is 1
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        start <- map["start"]
        end <- map["end"]
        day <- map["day"]
    }
}

class StoreInformation: Object, Mappable {
    
    var tipMinPercentage = RealmOptional<Double>()
    var tipMaxPercentage = RealmOptional<Double>()
    var tipDefaultPercentage = RealmOptional<Double>()
    var tipMinValue = RealmOptional<Double>()
    
    dynamic var phone: String?
    dynamic var address: String?
    var businessHours = List<BusinessHour>()
    
    var announcement: String {
//        switch I18NUtil.currentLanguage() {
//        case .CN:
//            return appendChineseAnnouncement()
//        case .EN:
//            return appendEnglishAnnouncement()
//        }
        return "xxxx"
    }
    
    var desp: String {
//        switch I18NUtil.currentLanguage() {
//        case .CN:
//            return despCn ?? ""
//        case .EN:
//            return despEn ?? ""
//        }
        return "xxxx"
    }
    
    let announcementCn = List<RealmStringObject>()
    let announcementEn = List<RealmStringObject>()
    dynamic var despCn: String?
    dynamic var despEn: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        tipMinPercentage <- (map["tipMinPercentage"], NumericTransform<Double>())
        tipMaxPercentage <- (map["tipMaxPercentage"], NumericTransform<Double>())
        tipDefaultPercentage <- (map["tipDefaultPercentage"], NumericTransform<Double>())
        tipMinValue <- (map["tipMinValue"], NumericTransform<Double>())
        phone <- map["phone"]
        address <- map["address"]
        businessHours <- (map["businessHour"], ListTransform<BusinessHour>())
        despCn <- map["description"]
        despEn <- map["descriptionEn"]
        
        var announcementCn: [String]? = nil
        announcementCn <- map["announcement"]
        announcementCn?.forEach({ (item) in
            let value = RealmStringObject()
            value.value = item
            self.announcementCn.append(value)
        })
        
        var announcementEn: [String]? = nil
        announcementEn <- map["announcementEn"]
        announcementEn?.forEach({ (item) in
            let value = RealmStringObject()
            value.value = item
            self.announcementEn.append(value)
        })
    }
    
    fileprivate func appendChineseAnnouncement() -> String {
        var string = ""
        if !announcementCn.isEmpty {
            for (index, element) in announcementCn.enumerated()  {
                string += "\(index + 1).\(element.value)"
            }
        }
        string = (string == "") ? "None." : string
        return string
    }
    
    fileprivate func appendEnglishAnnouncement() -> String {
        var string = ""
        if !announcementEn.isEmpty {
            for (index, element) in announcementEn.enumerated()  {
                string += "\(index).\(element.value)"
            }
        }
        string = (string == "") ? "None." : string
        return string
    }
}
