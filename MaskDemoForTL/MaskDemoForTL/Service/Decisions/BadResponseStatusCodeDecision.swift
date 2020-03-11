//
//  BadResponseStatusCodeDecision.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import Foundation

struct BadResponseStatusCodeDecision: Decision {
    func shouldApply<Req: Request>(request: Req, data: Data?, response: URLResponse?, error: Error?) -> Bool {
        guard let response = response as? HTTPURLResponse else {
            return true
        }
        return !(200...299).contains(response.statusCode)
    }
    
    func apply<Req: Request>(request: Req, data: Data?, response: URLResponse?, error: Error?, decisions: [Decision], completion: @escaping (DecisionAction<Req>) -> Void) {
        guard let response = response as? HTTPURLResponse else {
            let errRes = APIError(APIErrorCode.missingResponse.rawValue,
                                  APIErrorCode.missingResponse.description)
            completion(.errored(errRes))
            return
        }
        
        let errCode = handleHttpStatus(response)
        let errRes = APIError(response.statusCode, errCode.description)
        completion(.errored(errRes))
    }
    
    fileprivate func handleHttpStatus(_ response: HTTPURLResponse) -> APIErrorCode {
        switch response.statusCode {
        case 400...499: return APIErrorCode.clientError
        case 500...599: return APIErrorCode.serverError
        default:        return APIErrorCode.unknownError
        }
    }
}
