//  OMModel.swift
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

import Foundation
import ObjectMapper

public class OMNilModel: Mappable {
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
    }
    
}

public class OMString: Mappable {
    
    public var value: String?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        value <- map["data"]
    }
}

public class OMInt: Mappable {
    
    public var value: Int?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        value <- map["data"]
    }
}

public class OMDouble: Mappable {
    
    public var value: Double?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        value <- map["data"]
    }
}

public class OMStringCollection: Mappable {
    
    public var values: [String]?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        values <- map["data"]
    }
}

public class OMIntCollection: Mappable {
    
    public var values: [Int]?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        values <- map["data"]
    }
}

public class OMDoubleCollection: Mappable {
    
    public var values: [Double]?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        values <- map["data"]
    }
}
