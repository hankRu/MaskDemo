//
//  APIError.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import Foundation

public enum APIErrorCode: Int {
    case badRequest = 40000
    case encodingFailed = 40001
    case missingURL = 40002
    case authenticationError = 40100
    case invalidToken = 40300
    case missingResponse = 41000
    case missingData = 41001
    case unableToDecode = 42200
    case clientError = 49900
    case serverError = 50000
    case unknownError = 77777
    
    var description: String {
        switch self {
        case .badRequest:
            return "Bad request"
        case .encodingFailed:
            return "Parameter encoding failed."
        case .missingURL:
            return "URL is nil."
        case .authenticationError:
            return "You need to be authenticated first."
        case .invalidToken:
            return "Invalid Token !"
        case .missingResponse:
            return "Response returned with no Http response."
        case .missingData:
            return "Response returned with no data to decode."
        case .unableToDecode:
            return "We could not decode the response."
        case .clientError:
            return "Client Error"
        case .serverError:
            return "Server Error"
        case .unknownError:
            return "Unknown Error"
        }
    }
}

struct APIError: Error, LocalizedError {
    let statusCode: Int
    let message: String
    let details: String?
    
    init(_ code: Int, _ message: String, _ details: String? = nil) {
        self.statusCode = code
        self.message = message
        self.details = details
    }
    
    init(_ apiErrorCode: APIErrorCode, _ details: String? = nil) {
        self.statusCode = apiErrorCode.rawValue
        self.message = apiErrorCode.description
        self.details = details
    }
    
    var errorDescription: String? {
        return self.message
    }
}
