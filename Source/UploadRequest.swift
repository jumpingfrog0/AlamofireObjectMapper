//
//  UploadRequest.swift
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

public struct UploadModule: RawRepresentable {
    
    public typealias RawValue = String
    
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
}

extension UploadModule {
    static let Drawing = UploadModule("drawing")
    static let Public = UploadModule("public")
    static let UserHead = UploadModule("user-head")
    static let ChildHead = UploadModule("child-head")
    static let Background = UploadModule("background")
}

public class UploadRequest {
        
    private var fileURL: URL
    private var URLRequest: URLRequestConvertible
    
    init(fileURL: URL, URLRequest: URLRequestConvertible) {
        self.fileURL = fileURL
        self.URLRequest = URLRequest
    }
    
    public func upload<T: Mappable> (
        willStart: (() -> Void)? = nil,
        didStop: (() -> Void)? = nil,
        successHandler: (([T]?) -> Void)? = nil,
        failHandler: ((OMError?) -> Void)? = nil) {
            
            willStart?()
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(self.fileURL, withName: "fileURL")
                },
                with: URLRequest,
                encodingCompletion: { encodingResult in
                    
                    didStop?()

                    switch encodingResult {
                    case .success(let upload, _, _):

                        let completionHandler = { (response: DataResponse<[T]>) in

                            if response.result.error == nil {

                                successHandler?(response.result.value)

                            } else {

                                failHandler?(response.result.error as? OMError)
                            }
                        }

                        _ = upload.responseCollection(
                            completionHandler: completionHandler)
                        
                   case .failure(let encodingError):
                        
                        debugPrint(encodingError)
                    }
                }
            )
    }
    
    public func upload<T: Mappable> (
        willStart: (() -> Void)? = nil,
        didStop: (() -> Void)? = nil,
        successHandler: ((T?) -> Void)? = nil,
        failHandler: ((OMError?) -> Void)? = nil) {
        
            willStart?()
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(self.fileURL, withName: "fileURL")
                },
                with: URLRequest,
                encodingCompletion: { encodingResult in
                    
                    didStop?()
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        
                        let completionHandler = { (response: DataResponse<T>) in
                            
                            if response.result.error == nil {
                                
                                successHandler?(response.result.value)
                                
                            } else {
                                
                                failHandler?(response.result.error as? OMError)
                            }
                        }
                        
                        _ = upload.responseObject(
                            completionHandler: completionHandler)
                        
                    case .failure(let encodingError):
                        
                        debugPrint(encodingError)
                    }
                }
            )
    }
}

