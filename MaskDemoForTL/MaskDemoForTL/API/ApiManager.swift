//
//  ApiManager.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import Foundation

struct ApiDomain: DomainChangable {
    var multiDomain: MultiDomain {
        get {
            return MultiDomain(URLs: [""])
        }
        set {
            //StoredDefaults.baseURL.value = newValue.URLs
        }
    }
}

class ApiManager {
    static let shared = ApiManager()
    
    let router = Router()
    
    var domain: ApiDomain = ApiDomain()

    //MARK: - MaskData
    func getMaskData(completion: @escaping (Result<MaskData, Error>) ->()) {
        let req = MaskDataRequest()
        router.send(req, decisions: Decisions.shared.unEncrypted) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


