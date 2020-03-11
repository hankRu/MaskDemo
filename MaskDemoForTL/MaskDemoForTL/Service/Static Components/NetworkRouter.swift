//
//  NetworkRouter.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//
//

import Foundation

public typealias RouterCompletion = (Result<Data,Error>)->()

protocol NetworkRouter: class {
    func send<T:Request>(_ route: T, decisions: [Decision]?, completion: @escaping (Result<T.Response,Error>)->())
    func cancel()
}
