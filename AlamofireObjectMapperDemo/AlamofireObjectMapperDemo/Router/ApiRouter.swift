//  ApiRouter.swift
//  AlamofireObjectMapperDemo
//
//  Created by jumpingfrog0 on 11/01/2017.
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

enum APIRouter: URLRequestConvertible {
    
    #if DEBUG
    static let baseURLString = "http://localhost:3000"
    #else
    static let baseURLString = "http://localhost:3000"
    #endif
    
    // MARK: - Router
    case getUser
    case getAllUsers
    case singleString
    case singleInt
    case singleDouble
    case singleStringArray
    case singleIntArray
    case singleDoubleArray
    case uploadFile(toModule: UploadModule)
    case error
    case illegalAccessTokenError
    case illegalRefreshTokenError
    case refreshToken(parameters: Parameters)
    
    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        // MARK: GET
        case .getUser:
            return .get
        case .getAllUsers:
            return .get
        case .singleString:
            return .get
        case .singleInt:
            return .get
        case .singleDouble:
            return .get
        case .singleStringArray:
            return .get
        case .singleIntArray:
            return .get
        case .singleDoubleArray:
            return .get
        case .uploadFile(_):
            return .post
        case .error:
            return .get
        case .illegalAccessTokenError:
            return .get
        case .illegalRefreshTokenError:
            return .get
        case .refreshToken(_):
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getUser:
            return "/user"
        case .getAllUsers:
            return "/users"
        case .singleString:
            return "/singleString"
        case .singleInt:
            return "/singleInt"
        case .singleDouble:
            return "/singleDouble"
        case .singleStringArray:
            return "/singleStringArray"
        case .singleIntArray:
            return "/singleIntArray"
        case .singleDoubleArray:
            return "/singleDoubleArray"
        case .uploadFile(let module):
            return "/upload/" + module.rawValue
        case .error:
            return "error"
        case .illegalAccessTokenError:
            return "illegalAccessTokenError"
        case .illegalRefreshTokenError:
            return "illegalRefreshTokenError"
        case .refreshToken(_):
            return "refreshToken"
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try APIRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        let token = AuthorizationHandler.getAuthorizationToken()
        urlRequest.setValue("\(token)", forHTTPHeaderField: HttpHeaderFields.AuthorizationToken)
        urlRequest.setValue("1", forHTTPHeaderField: HttpHeaderFields.ErrorDetail)
        
        switch self {
        case .refreshToken(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}

