//
//  Alamofire+ResponseSerializer.swift
//  AlamofireObjectMapperDemo
//
//  Created by jumpingfrog0 on 10/01/2017.
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

import Alamofire
import ObjectMapper

extension Request {
    
    private static func genericObjectSerializer<T: Mappable>(keyPath: String? = nil) -> DataResponseSerializer<T> {
        
        return DataResponseSerializer<T> { request, response, data, error in
        
            // Http Error with http status code
            guard error == nil else {
                return .failure(OMError.network(error: error!, code: .networkError))
            }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
//            let result = Request.serializeResponseJSON(options: .allowFragments, response: response, data: data, error: nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(OMError.jsonSerializationFailed(error: result.error! as! AFError, code: .jsonSerializationFailed))
            }
            
            guard let json = jsonObject as? [String : AnyObject] else {
                return .failure(OMError.jsonObjectDowncastFailed(reason: .responseJsonInvalid, code: .jsonObjectDowncastFailed))
            }
            
            guard let resultJson = json["result"] as? [String : AnyObject] else {
                return .failure(OMError.jsonObjectDowncastFailed(reason: .resultJsonInvalid, code: .jsonObjectDowncastFailed))
            }
            
            guard let code = resultJson["code"] as? Int else {
                return .failure(OMError.jsonObjectDowncastFailed(reason: .codeSectionInvalid, code: .jsonObjectDowncastFailed))
            }
            
            guard let message = resultJson["message"] as? String else {
                return .failure(OMError.jsonObjectDowncastFailed(reason: .messageSectionInvalid, code: .jsonObjectDowncastFailed))
            }
            
            guard code == 0 else {
                return .failure(OMError.serviceError(message: message, code: code))
            }
            
            // request success
            var dataJson: [String: AnyObject]?
            if keyPath == nil { // single request
                
                dataJson = resultJson
                
            } else {
                
                if resultJson[keyPath!] == nil { // request success but no response data
                    dataJson = ["" : "" as AnyObject]
                } else {
                    dataJson = resultJson[keyPath!] as? [String: AnyObject]
                }
            }
            
            
            guard let _ = dataJson else {
                return .failure(OMError.jsonObjectDowncastFailed(reason: .dataSectionInvalidObject, code: .jsonObjectDowncastFailed))
            }
            
            guard let parsedObject = Mapper<T>().map(JSONObject: dataJson) else {
                return .failure(OMError.objectSerializationFailed(reason: "JSON could not be serialized to \"\(T.self)\" object.", code: .objectSerializationFailed))
            }
            
            // parse extra json
            if let extraJson = resultJson["extraMsg"] as? [[String: AnyObject]],
                let parsedExtraMsg = Mapper<ExtraModel>().mapArray(JSONArray: extraJson) {
                NotificationCenter.default.post(name: .ParsedExtraMsg, object: nil, userInfo: ["extraMsg" : parsedExtraMsg])
            }
            
            return .success(parsedObject)
        }
    }
    
    public static func singleSerializer<T: Mappable>() -> DataResponseSerializer<T> {
        return genericObjectSerializer()
    }
    
    public static func objectSerializer<T: Mappable>() -> DataResponseSerializer<T> {
        return genericObjectSerializer(keyPath: "data")
    }
    
    public static func collectionSerializer<T: Mappable>() -> DataResponseSerializer<[T]> {
        
        return DataResponseSerializer<[T]> { request, response, data, error in
            
            // Http Error with http status code
            guard error == nil else {
                return .failure(OMError.network(error: error!, code: .networkError))
            }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
            //            let result = Request.serializeResponseJSON(options: .allowFragments, response: response, data: data, error: nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(OMError.jsonSerializationFailed(error: result.error! as! AFError, code: .jsonSerializationFailed))
            }
            
            guard let json = jsonObject as? [String : AnyObject] else {
                return .failure(OMError.jsonObjectDowncastFailed(reason: .responseJsonInvalid, code: .jsonObjectDowncastFailed))
            }
            
            guard let resultJson = json["result"] as? [String : AnyObject] else {
                return .failure(OMError.jsonObjectDowncastFailed(reason: .resultJsonInvalid, code: .jsonObjectDowncastFailed))
            }
            
            guard let code = resultJson["code"] as? Int else {
                return .failure(OMError.jsonObjectDowncastFailed(reason: .codeSectionInvalid, code: .jsonObjectDowncastFailed))
            }
            
            guard let message = resultJson["message"] as? String else {
                return .failure(OMError.jsonObjectDowncastFailed(reason: .messageSectionInvalid, code: .jsonObjectDowncastFailed))
            }
            
            guard code == 0 else {
                return .failure(OMError.serviceError(message: message, code: code))
            }
            
            
            // request success
            let data = resultJson["data"]
            var dataJson: [[String: AnyObject]]?
            if data == nil { // request success but no response data
                dataJson = [["" : "" as AnyObject]]
            } else {
                dataJson = data as? [[String: AnyObject]]
            }
            
            guard let _ = dataJson else {
                return .failure(OMError.jsonObjectDowncastFailed(reason: .dataSectionInvalidCollection, code: .jsonObjectDowncastFailed))
            }
            
            guard let parsedObject = Mapper<T>().mapArray(JSONArray: dataJson!) else {
                return .failure(OMError.objectSerializationFailed(reason: "JSON could not be serialized to \"\(T.self)\" collection objects.", code: .objectSerializationFailed))
            }
            
            // parse extra json
            if let extraJson = resultJson["extraMsg"] as? [[String: AnyObject]],
                let parsedExtraMsg = Mapper<ExtraModel>().mapArray(JSONArray: extraJson) {
                NotificationCenter.default.post(name: .ParsedExtraMsg, object: nil, userInfo: ["extraMsg" : parsedExtraMsg])
            }
            
            return .success(parsedObject)
        }
    }
}
