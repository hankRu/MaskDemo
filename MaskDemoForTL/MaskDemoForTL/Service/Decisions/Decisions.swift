//
//  Decision.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//


import Foundation

struct Decisions {
    static var shared = Decisions()
    
    lazy var unEncrypted: [Decision] =
        [
            RetryDecision(retryCount: 3),
            BadResponseStatusCodeDecision(),
            ParseResultDecision()
        ]
    
    lazy var refreshToken: [Decision] =
        [
            RetryDecision(retryCount: 3),
            BadResponseStatusCodeDecision()
        ]
    
    lazy var defaults: [Decision] =
        [
            RetryDecision(retryCount: 3),
            BadResponseStatusCodeDecision()
        ]
}




