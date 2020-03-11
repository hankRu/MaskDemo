//
//  MaskDataRequest.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import Foundation

struct MaskDataRequest: Request {
    typealias Response = MaskData
    
    var multiDomain: MultiDomain {
        return MultiDomain(URLs: ["https://raw.githubusercontent.com/"])
    }
    
    var path: String {
        return "kiang/pharmacies/master/json/points.json"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var urlParameters: Parameters? {
        return [:]
    }
    
    var bodyEncoding: ParameterEncoding? {
        return .urlEncoding
    }
    
    var headers: HTTPHeaders? {
        return [:]
    }
}
