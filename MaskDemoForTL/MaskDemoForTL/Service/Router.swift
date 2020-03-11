//
//  Router.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import Foundation

class Router: NetworkRouter {
    private var task: URLSessionTask?
    private var timeoutInterval = 10.0
    
    func send<T: Request>(_ request: T, decisions: [Decision]? = nil, completion: @escaping (Result<T.Response, Error>)->()) {
        let session = URLSession.shared
        do {
            let formatRequest = try self.buildRequest(from: request)
            task = session.dataTask(with: formatRequest, completionHandler: { [weak self, decisions] data, response, error in
                guard let self = self else {return}

                self.handleDecision(request: request,
                                    data: data,
                                    response: response,
                                    error: error,
                                    decisions: decisions ?? Decisions.shared.defaults,
                                    handler: completion)
            })
        } catch {
            let errRes = APIError(APIErrorCode.clientError.rawValue,
                                  error.localizedDescription)
            completion(.failure(errRes))
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest<T: Request>(from route: T) throws -> URLRequest {
        var request = URLRequest(url: URL(string: route.baseURL + "\(route.path)")!,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: timeoutInterval)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            if(route.bodyEncoding == nil) {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } else {
                try self.configureParameters(bodyParameters: route.parameters,
                                             bodyEncoding: route.bodyEncoding!,
                                             urlParameters: route.urlParameters,
                                             request: &request)
            }
            
            if let additionalHeaders = route.headers {
                self.addAdditionalHeaders(additionalHeaders, request: &request)
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func handleDecision<Req: Request>(request: Req, data: Data?, response: URLResponse?, error: Error?, decisions: [Decision], handler: @escaping (Result<Req.Response, Error>) -> Void) {
        guard !decisions.isEmpty else {
            fatalError("No decision left but did not reach a stop.")
        }

        var decisions = decisions
        let current = decisions.removeFirst()
        guard current.shouldApply(request: request, data: data, response: response, error: error) else {
            handleDecision(request: request,
                           data: data,
                           response: response,
                           error: error,
                           decisions: decisions,
                           handler: handler)
            return
        }
        print("Apply Decision : \(request.path) - \(current)")
        current.apply(request: request, data: data, response: response, error: error, decisions: decisions) { action in
            switch action {
            case .continueWithData(let data, let response):
                self.handleDecision(request: request,
                                    data: data,
                                    response: response,
                                    error: error,
                                    decisions: decisions,
                                    handler: handler)
            case .restartWith(let request, let decisions):
                self.send(request, decisions: decisions, completion: handler)
            case .errored(let error):
                print("\n - - - - - - - Decision Handler END with failure - - - - - - - - \n")
                handler(.failure(error))
            case .done(let value):
                print("\n - - - - - - - Decision Handler END with success - - - - - - - - \n")
                handler(.success(value))
            }
        }
    }
}
