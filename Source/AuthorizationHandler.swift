//  AuthorizationHandler.swift
//  AlamofireObjectMapperDemo
//
//  Created by jumpingfrog0 on 12/01/2017.
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

public struct HttpHeaderFields {
    static let AuthorizationToken = "AuthorizationToken"
    static let RefreshToken = "RefreshToken"
    static let ErrorDetail = "X-Response-ErrorDetail"
}

public class AuthorizationHandler: RequestAdapter, RequestRetrier {
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void

    private let lock = NSLock()
    
    private var accessToken: String?
    private var refreshToken: String?
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    public init(accessToken: String?, refreshToken: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    public convenience init() {
        self.init(accessToken: AuthorizationHandler.getAuthorizationToken(), refreshToken: AuthorizationHandler.getRefreshToken())
    }
    
    // MARK: - RequestAdapter
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if let token = AuthorizationHandler.getAuthorizationToken() {
            // FIXME: fixing hard code access token key
            // Please change your access token key
            urlRequest.setValue("\(token)", forHTTPHeaderField: HttpHeaderFields.AuthorizationToken)
        }
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        if request.retryCount >= 1 {
            completion(false, 0.0)
            return
        }
        
        // handle illegal access token error
        guard let error = error as? OMError,
            error.serviceError?.code == SessionManager.default.serviceErrorCode?.illegalAccessToken else {
                completion(false, 0.0)
                return
        }
        
        requestsToRetry.append(completion)
        
        if !isRefreshing {
            refreshTokens{ [unowned self] (succeeded, accessToken, refreshToken) in
                self.lock.lock()
                defer {
                    self.lock.unlock()
                }
                
                if let accessToken = accessToken, let refreshToken = refreshToken {
                    self.accessToken = accessToken
                    self.refreshToken = refreshToken
                    
                    AuthorizationHandler.saveRefreshToken(refreshToken)
                    AuthorizationHandler.saveAuthorizationToken(accessToken)
                }
                
                self.requestsToRetry.forEach { $0(succeeded, 0.0) }
                self.requestsToRetry.removeAll()
            }
        }
    }
    
    // FIXME: fixing refresh token via external dependency(`APIRouter.refreshToken`)
    // Please change you request router and refresh token key
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        // Please change your refresh token key
        let params = [
            HttpHeaderFields.RefreshToken : AuthorizationHandler.getRefreshToken()
        ]
        _ = ObjectRequest(URLRequest: APIRouter.refreshToken(parameters: params))
            .load(willStart: {
                
                self.isRefreshing = true
                jf_print("Will start refresh access token request.")
            
            }, didStop: {
            
                self.isRefreshing = false
                jf_print("Did stop refresh access token request.")
            
            }, successHandler: { (authorization: Authorization?) in
                
                completion(true, authorization?.accessToken, authorization?.refreshToken)
            
            }, failHandler: { (error: OMError?) in
            
                jf_print(error!.errorDescription)
                completion(false, nil, nil)
            })
    }
    
    deinit {
        jf_print("AuthorizationHandler -- deinit")
    }
}

extension AuthorizationHandler {
    class func saveAuthorizationToken(_ token: String?) {
        let prefs = UserDefaults.standard
        prefs.set(token, forKey: "AuthorizationTokenKey")
        prefs.synchronize()
    }
    
    class func getAuthorizationToken() -> String? {
        return UserDefaults.standard.object(forKey: "AuthorizationTokenKey") as? String
    }
    
    class func saveRefreshToken(_ token: String?) {
        let prefs = UserDefaults.standard
        prefs.set(token, forKey: "RefreshTokenKey")
        prefs.synchronize()
    }
    
    class func getRefreshToken() -> String? {
        return UserDefaults.standard.object(forKey: "RefreshTokenKey") as? String
    }
}
