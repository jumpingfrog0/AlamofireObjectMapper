//
//  ViewController.swift
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

import UIKit
import ObjectMapper
import Alamofire
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        objectRequest()
//        collectionRequest()
//        singleRequest()
//        uploadRequest()
//        errorRequest()
        
//        reauthRequest()
//        test()
//        realmTest()
        getStores()
    }
    
    func collectionRequest() {
        _ = CollectionRequest(URLRequest: APIRouter.getAllUsers).load(willStart: {
            
            jf_print("will start")
            
        }, didStop: {
            
            jf_print("did stop")
            
        }, successHandler: { (users: [User]?) in
            
            let peny = users?.last
            jf_print(peny?.name)
            
        }, failHandler: { (error: OMError?) in
            
            guard let serviceError = error?.serviceError, serviceError.code == ServiceErrorCode.invalidData.rawValue else {
                jf_print(error!.errorDescription)
                return
            }
            
            jf_print("handle service error: \(serviceError.message)")
        })
    }
    
    func objectRequest() {
        _ = ObjectRequest(URLRequest: APIRouter.getUser).load(willStart: {

            jf_print("will start")

        }, didStop: {

            jf_print("did stop")

        }, successHandler: { (user : User?) in

            jf_print(user?.name)

        }, failHandler: { (error: OMError?) in

            guard let serviceError = error?.serviceError, serviceError.code == ServiceErrorCode.invalidData.rawValue else {
                jf_print(error!.errorDescription)
                return
            }
            
            jf_print("handle service error: \(serviceError.message)")
        })
    }
    
    func singleRequest() {
        _ = SingleRequest(URLRequest: APIRouter.singleString).load(willStart: {
            
            jf_print("will start")
            
        }, didStop: {
            
            jf_print("did stop")
            
        }, successHandler: { (string : OMString?) in
            
            jf_print(string?.value)
            
        }, failHandler: { (error: OMError?) in
            
            guard let serviceError = error?.serviceError, serviceError.code == ServiceErrorCode.invalidData.rawValue else {
                jf_print(error!.errorDescription)
                return
            }
            
            jf_print("handle service error: \(serviceError.message)")
        })
    }
    
    func uploadRequest() {
        
        NotificationCenter.default.post(name: .ParsedExtraMsg, object: nil)
        
        _ = UploadRequest(fileURL: URL(string: "http://baidu.com")!, URLRequest: APIRouter.uploadFile(toModule: .Test))
    }
    
    func errorRequest() {
        
        // Custom code of illegal access token error
//        var serviceErrorCode = SessionManager.OMCode()
//        serviceErrorCode.illegalAccessToken = 1002
//        SessionManager.default.serviceErrorCode = serviceErrorCode
        
        _ = SingleRequest(URLRequest: APIRouter.illegalAccessTokenError).load(willStart: {
            
            jf_print("will start")
            
        }, didStop: {
            
            jf_print("did stop")
            
        }, successHandler: { (string : OMString?) in
            
            jf_print(string?.value)
            
        }, failHandler: { (error: OMError?) in
            
            guard let serviceError = error?.serviceError, serviceError.code == ServiceErrorCode.invalidData.rawValue else {
                jf_print(error!.errorDescription)
                return
            }
            
            jf_print("handle service error: \(serviceError.message)")
        })
    }
    
    func reauthRequest() {
        _ = SingleRequest(URLRequest: APIRouter.illegalAccessTokenError).load(willStart: {
            
            jf_print("will start")
            
        }, didStop: {
            
            jf_print("did stop")
            
        }, successHandler: { (_ : OMNilModel?) in
            
            jf_print("retry success")
            
        }, failHandler: { (error: OMError?) in
            
            guard let serviceError = error?.serviceError, serviceError.code == ServiceErrorCode.invalidData.rawValue else {
                jf_print(error!.errorDescription)
                return
            }
            
            jf_print("handle service error: \(serviceError.message)")
        })
    }
    
    func test() {
        let a = "2.2.0"
        let b = "2.1.0"
        
        switch a.compare(b) {
        case .orderedAscending:
            jf_print("asc")
        case .orderedDescending:
            jf_print("desc")
        default:
            break
        }
    }

    func realmTest() {
        
        _ = CollectionRequest(URLRequest: APIRouter.getFoobar)
            .load(willStart: {
                
            }, didStop: { 
                
            }, successHandler: { (foobar: [FooBar]?) in
                
                jf_print(foobar)
                
                let a = foobar
                print(a)
                
//                if (a == FooBar) {
//                    
//                }
                
//                if foobar!.save() {
//                    jf_print("save succeeded.")
//                    
//                } else {
//                    jf_print("save failed.")
//                }
                
            }, failHandler: { (error: OMError?) in
                
            })
        
//        _ = ObjectRequest(URLRequest: APIRouter.getUser)
//            .load(willStart: {
//                
//            }, didStop: {
//                
//            }, successHandler: { (user: User?) in
//                
//                jf_print(user)
//                jf_print(user?.goods)
//                jf_print(user?.goods.isEmpty)
//                
//                if user!.save() {
//                    jf_print("save succeeded.")
//                    
//                } else {
//                    jf_print("save failed.")
//                }
//                
//            }, failHandler: { (error: OMError?) in
//                
//            })
    }
    
    func getStores() {
        _ = CollectionRequest(URLRequest: APIRouter.getAllStores).load(
            willStart: { () -> Void in
                
        }, didStop: { () -> Void in
            
        }, successHandler: { (stores: [Store]?) -> Void in
            
            let a = stores
            jf_print(a)
            
            jf_print(stores?[0])
            jf_print(stores?[1])
            jf_print(stores)
            
        }, failHandler: { (error: OMError?) -> Void in
            
        })
    }
}


extension UploadModule {
    static let Test = UploadModule("test")
}
