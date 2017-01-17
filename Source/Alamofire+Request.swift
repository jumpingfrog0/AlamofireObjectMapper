//
//  Alamofire+Request.swift
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

import Foundation
import Alamofire
import ObjectMapper

/** Response Format
 
     Response Single:
     
     {
        "result" : {
            "code": 0,
            "message": "message",
            "data" : "xxx",
            "extraMsg" : {
                "type" : "POINT",
                "data" : {
                     "value" : 100,
                     "message" : "xxxx"
                }
            }
        }
     }
 
 
    Response Object:
 
     {
        "result" : {
            "code": 0,
            "message": "message",
            "data" : {
                "xxx" : "xxx",
                "xx" : xx
            }
            "extraMsg" : {
                "type" : "POINT",
                "data" : {
                    "value" : 100,
                    "message" : "xxxx"
                }
            }
        }
     }
 

    Response Collection:
 
    {
        "result" : {
            "code": 0,
            "message": "message",
            "data" : [
                {
                    "xxx" : "xxx",
                    "xxx" : xx
                },
                {
                    "xxx" : "xxx",
                    "xx" : xx
                }
            ]
            "extraMsg" : {
                "type" : "POINT",
                "data" : {
                    "value" : 100,
                    "message" : "xxxx"
                }
            }
        }
    }

*/

extension DataRequest {
    
    public func responseSingle<T: Mappable> (
        queue: DispatchQueue? = nil,
        willStart: (() -> Void)? = nil,
        didStop: (() -> Void)? = nil,
        //        oauthHandler: (Response<T, OMError> -> Void)? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        willStart?()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return response(queue: queue, responseSerializer: Request.singleSerializer(), completionHandler: { (response: DataResponse<T>) in
            
            self.delegate.queue.addOperation {
                self.printObjectResponse(response: response)
                
                (queue ?? DispatchQueue.main).async {
                    didStop?()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completionHandler(response)
                }
            }
        })
    }
    
    public func responseObject<T: Mappable> (
        queue: DispatchQueue? = nil,
        willStart: (() -> Void)? = nil,
        didStop: (() -> Void)? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        willStart?()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return response(queue: queue, responseSerializer: Request.objectSerializer(), completionHandler: { (response: DataResponse<T>) in
            
            self.delegate.queue.addOperation {
                self.printObjectResponse(response: response)
                
                (queue ?? DispatchQueue.main).async {
                    didStop?()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completionHandler(response)
                }
            }
        })
    }
    
    public func responseCollection<T: Mappable> (
        queue: DispatchQueue? = nil,
        willStart: (() -> Void)? = nil,
        didStop: (() -> Void)? = nil,
        //        oauthHandler: (Response<T, OMError> -> Void)? = nil,
        completionHandler: @escaping (DataResponse<[T]>) -> Void)
        -> Self
    {
        willStart?()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return response(queue: queue, responseSerializer: Request.collectionSerializer(), completionHandler: { (response: DataResponse<[T]>) in
            
            self.delegate.queue.addOperation {
                self.printCollectionResponse(response: response)
                
                (queue ?? DispatchQueue.main).async {
                    didStop?()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completionHandler(response)
                }
            }
        })
    }
    
    private func printObjectResponse<T: Mappable> (response: DataResponse<T>) {
        
        print(data: response.data!, value: response.result.value, response: response.response, error: response.result.error
        )
    }
    
    private func printCollectionResponse<T: Mappable> (response: DataResponse<[T]>) {
        
        print(data: response.data!, value: response.result.value, response: response.response, error: response.result.error
        )
    }
    
    private func print<T>(data: Data, value: T?, response: HTTPURLResponse?, error: Error?) {
        
        #if DEBUG
        let jsonString = String(data: data, encoding: String.Encoding.utf8)
        
        if let _ = value {
            
            // Request success
            jf_print("\n================================ HTTP REQUEST SUCCESS BEGIN ================================\n\n"
                + "REQUEST = \(description)\n\n"
                + "CURL = \(debugDescription)\n\n"
                + "RESPONSE = \(response)\n\n"
                + "JSON = \(jsonString!)\n\n"
                + "================================ HTTP REQUEST SUCCESS END ================================\n"
            )
        } else {
            
            // Unknown error
            guard let error = error as? OMError else {
                jf_print("\n================================ HTTP REQUEST FAIL BEGIN ================================\n"
                    + "REQUEST = \(description)\n\n"
                    + "CURL = \(debugDescription)\n\n"
                    + "RESPONSE = \(response)\n\n"
                    + "ERROR TYPE : Unknown error\n\n"
                    + "RESPONSE ERROR = Unknown error\n\n"
                    + "================================ HTTP REQUEST FAIL END ================================\n"
                )
                return
            }
            
            if let _ = error.serviceError {
                
                // Service error
                jf_print("\n================================ HTTP REQUEST FAIL BEGIN ================================\n"
                    + "REQUEST = \(description)\n\n"
                    + "CURL = \(debugDescription)\n\n"
                    + "RESPONSE = \(response)\n\n"
                    + "ERROR TYPE : Service error\n\n"
                    + "RESPONSE ERROR = \(jsonString!)\n\n"
                    + "================================ HTTP REQUEST FAIL END ================================\n"
                )
            } else {
                
                // Network or parsing error
                jf_print("\n================================ HTTP REQUEST FAIL BEGIN ================================\n"
                    + "REQUEST = \(description)\n\n"
                    + "CURL = \(debugDescription)\n\n"
                    + "RESPONSE = \(response)\n\n"
                    + "ERROR TYPE : Network or parsing error\n\n"
                    + "RESPONSE ERROR = \(error.errorDescription)\n\n"
                    + "JSON = \(jsonString!)\n\n"
                    + "================================ HTTP REQUEST FAIL END ================================\n"
                )
                
            }
        }
        #endif
    }
}
