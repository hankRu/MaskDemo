//
//  ParseResultDecision.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//


import Foundation

struct ParseResultDecision: Decision {
    func shouldApply<Req: Request>(request: Req, data: Data?, response: URLResponse?, error: Error?) -> Bool {
        return true
    }

    func apply<Req: Request>(request: Req, data: Data?, response: URLResponse?, error: Error?, decisions: [Decision], completion: @escaping (DecisionAction<Req>) -> Void) {
        guard let data = data else {
            let errRes = APIError(APIErrorCode.missingData.rawValue,
                                  APIErrorCode.missingData.description)
            completion(.errored(errRes))
            return
        }
        
        do {
            let value = try JSONDecoder().decode(Req.Response.self, from: data)
            completion(.done(value))
        } catch {
            let err = APIError(APIErrorCode.unableToDecode.rawValue,
                               APIErrorCode.unableToDecode.description)
            completion(.errored(err))
        }
    }
}
