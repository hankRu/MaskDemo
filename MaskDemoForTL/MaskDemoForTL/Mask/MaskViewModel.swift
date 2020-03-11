//
//  MaskViewModel.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import UIKit

class MaskViewModel: NSObject {
    
    var reloadData: Observable<Bool> = Observable(false)
    
    var isLoading: Observable<Bool> = Observable(true)
    
    var cellViewModels: [Feature] = []
    
    var filterModels: [Feature] = []
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    override init() {
        
    }
    
    func initFetch() {
        self.isLoading.value = true
        ApiManager.shared.getMaskData() { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.cellViewModels = model.features
                self.filterModels = model.features
                
            case .failure(let error):
                print("\(error)")
            }
            self.reloadData.value = true
            self.isLoading.value = false
        }
    }
    
    func filterData(category: String, completion: @escaping (_ aera: String) -> ()) {
        if category == "全台" {
            filterModels = cellViewModels
            completion(category)
            return
        }
        
        let filters = cellViewModels.filter { (feature) -> Bool in
            feature.properties.county == category
        }
        
        filterModels = filters
        completion(category)
        self.reloadData.value = true
    }
}
