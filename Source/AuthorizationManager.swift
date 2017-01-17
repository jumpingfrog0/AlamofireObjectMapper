//
//  AuthorizationManager.swift
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

@available(*, deprecated: 10.0, message: "No longer needed. Instead of `AuthorizationHandler`")
public class AuthorizationManager {
    
    private typealias CachedTask = (HTTPURLResponse?, AnyObject?, OMError?) -> Void
    
    private var cachedTasks = Array<CachedTask>()
    private var isRefreshing = false
    
    @available(*, deprecated: 10.0, message: "No longer needed.")
    class var sharedInstance: AuthorizationManager {
        struct Singleton {
            static let instance = AuthorizationManager()
        }
        return Singleton.instance
    }
    
    private struct AssociatedKeys {
        static let AuthorizationTokenKey = "AuthorizationTokenKey"
        static let RefreshTokenKey = "RefreshTokenKey"
    }
    
    func reauthenticateObjectRequest<T: Mappable>(request: NSURLRequest?, completionHandler: @escaping (DataResponse<T>) -> Void) {
        
        let cachedTask: CachedTask = { URLReponse, data, error in
            
            if var headers = request?.allHTTPHeaderFields, let accessToken = AuthorizationManager.getAuthorizationToken() {
                
                headers[HttpHeaderFields.AuthorizationToken] =  accessToken
                
                let authorizedHTTPRequest = request?.mutableCopy() as! NSMutableURLRequest
                authorizedHTTPRequest.allHTTPHeaderFields = headers
                
                _ = Alamofire.request(authorizedHTTPRequest as! URLRequestConvertible).responseObject(completionHandler: completionHandler)
            }
        }
        
        if self.isRefreshing {
            self.cachedTasks.append(cachedTask)
            return
        }
        
        self.cachedTasks.append(cachedTask)
        self.refreshToken()
    }
    
    func reauthenticateCollectionRequest<T: Mappable>(request: NSURLRequest?, completionHandler: @escaping (DataResponse<[T]>) -> Void) {
        
        let cachedTask: CachedTask = { URLReponse, data, error in
            
            if var headers = request?.allHTTPHeaderFields, let accessToken = AuthorizationManager.getAuthorizationToken() {
                
                headers[HttpHeaderFields.AuthorizationToken] =  accessToken
                
                let authorizedHTTPRequest = request?.mutableCopy() as! NSMutableURLRequest
                authorizedHTTPRequest.allHTTPHeaderFields = headers
                
                _ = Alamofire.request(authorizedHTTPRequest as! URLRequestConvertible).responseCollection(completionHandler: completionHandler)
            }
        }
        
        if self.isRefreshing {
            self.cachedTasks.append(cachedTask)
            return
        }
        
        self.cachedTasks.append(cachedTask)
        self.refreshToken()
    }
    
    func refreshToken() {
        
        isRefreshing = true
        
        let refreshToken = AuthorizationManager.getRefreshToken() ?? ""
        
        let params = ["refresh_token" : refreshToken]
        _ = ObjectRequest(URLRequest: APIRouter.refreshToken(parameters: params)).load(
            willStart: { () -> Void in
                
                jf_print("willStart refresh token request")
                
            }, didStop: { () -> Void in
                
                jf_print("didStop refresh token request")
                
                self.isRefreshing = false
                
            }, successHandler: { (authorization: Authorization?) -> Void in
                
                AuthorizationManager.saveRefreshToken(token: authorization?.refreshToken)
                AuthorizationManager.saveAuthorizationToken(token: authorization?.accessToken)
                
                let cachedTaskCopy = self.cachedTasks
                self.cachedTasks.removeAll()
                cachedTaskCopy.forEach { $0(nil, nil, nil) }
                
            }, failHandler: { (error: OMError?) -> Void in
                
                jf_print(error?.errorDescription)
        })
    }
    
    class func saveAuthorizationToken(token: String?) {
        let prefs = UserDefaults.standard
        prefs.set(token, forKey: AssociatedKeys.AuthorizationTokenKey)
        prefs.synchronize()
    }
    
    @available(*, deprecated: 10.0, message: "No longer needed.")
    class func getAuthorizationToken() -> String? {
        return UserDefaults.standard.object(forKey: AssociatedKeys.AuthorizationTokenKey) as? String
    }
    
    class func saveRefreshToken(token: String?) {
        let prefs = UserDefaults.standard
        prefs.set(token, forKey: AssociatedKeys.RefreshTokenKey)
        prefs.synchronize()
    }
    
    @available(*, deprecated: 10.0, message: "No longer needed.")
    class func getRefreshToken() -> String? {
        return UserDefaults.standard.object(forKey: AssociatedKeys.RefreshTokenKey) as? String
    }
    
}
