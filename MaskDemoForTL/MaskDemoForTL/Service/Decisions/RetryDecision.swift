//
//  RetryDecision.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//


import Foundation

struct RetryDecision: Decision {
    let retryCount: Int
    
    func shouldApply<Req>(request: Req, data: Data?, response: URLResponse?, error: Error?) -> Bool where Req : Request {
        guard error == nil, let response = response as? HTTPURLResponse, let _ = data else {
            return true
        }
                
        let isStatusCodeValid = (200...299).contains(response.statusCode)
        return !isStatusCodeValid
    }
    
    func apply<Req>(request: Req, data: Data?, response: URLResponse?, error: Error?, decisions: [Decision], completion: @escaping (DecisionAction<Req>) -> Void) where Req : Request {
        var request = request
        request.setNextDomain()
        
        let retryDecision = RetryDecision(retryCount: retryCount - 1)
        let newDecisions = decisions.inserting(retryDecision, at: 0)
        if retryCount > 0 {
            completion(.restartWith(request, newDecisions))
        } else {
            var errRes: APIError!
            
            if let error = error {
                errRes = APIError(APIErrorCode.clientError.rawValue,
                                      error.localizedDescription)
                completion(.errored(errRes))
                return
            }
            
            guard let _ = response as? HTTPURLResponse else {
                errRes = APIError(APIErrorCode.missingResponse.rawValue,
                                  APIErrorCode.missingResponse.description)
                completion(.errored(errRes))
                return
            }
            
            guard data != nil else {
                errRes = APIError(APIErrorCode.missingData.rawValue,
                                  APIErrorCode.missingData.description)
                completion(.errored(errRes))
                return
            }
            
            errRes = APIError(APIErrorCode.unknownError.rawValue,
                              APIErrorCode.unknownError.description)
            completion(.errored(errRes))
        }
    }
}
