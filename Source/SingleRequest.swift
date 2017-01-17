//
//  SingleRequest.swift
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

public class SingleRequest {
    private var URLRequest: URLRequestConvertible
    
    public init(URLRequest: URLRequestConvertible) {
        self.URLRequest = URLRequest
    }
    
    public func load<T: Mappable>(
        willStart: (() -> Void)? = nil,
        didStop: (() -> Void)? = nil,
        successHandler: ((T?) -> Void)? = nil,
        failHandler: ((OMError?) -> Void)? = nil)
        -> Self {

            let completionHandler = { (response: DataResponse<T>) in
                
                // default
                
                if response.result.error == nil {
                    
                    successHandler?(response.result.value)
                    
                } else {
                    
                    failHandler?(response.result.error as? OMError)
                }
            }
            
            let authHandler = AuthorizationHandler()
            SessionManager.default.adapter = authHandler
            SessionManager.default.retrier = authHandler
            
            _ = request(URLRequest)
                .validate({ (request, response, data) -> Request.ValidationResult in
                    
                    if SessionManager.default.serviceErrorCode == nil {
                        SessionManager.default.serviceErrorCode = SessionManager.OMCode()
                    }
                    
                    let responseSerializer: DataResponseSerializer<T>  = Request.singleSerializer()
                    let result = responseSerializer.serializeResponse(request, response, data, nil)
                    
                    if case let .failure(error) = result {
                        
                        if let error = error as? OMError {
                            switch error {
                                // Only encounter illegal access token error, validation failed, and then retry request.
                            case .serviceError(_, code: SessionManager.default.serviceErrorCode!.illegalAccessToken):
                                
                                return Request.ValidationResult.failure(error)
                                
                            default:
                                return Request.ValidationResult.success
                            }
                        }
                    }
                    
                    return Request.ValidationResult.success
                })
                .responseSingle(
                    
                    willStart: willStart,
                    didStop: didStop,
                    completionHandler: completionHandler
                )
        
        return self
    }
}
