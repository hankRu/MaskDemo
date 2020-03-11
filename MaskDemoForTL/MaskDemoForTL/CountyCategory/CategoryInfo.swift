//
//  CategoryInfo.swift
//  StrayAnimals
//
//  Created by Hank Lu on 2019/12/2.
//  Copyright © 2019 Minhan Ru. All rights reserved.
//

import Foundation

struct CategoryInfo {
    
    static var shared = CategoryInfo()
    
    // MARK: - 通知事件
    var didChangeCategory: Observables<(Int)> = Observables(0)
    
    // MARK: -
    lazy var categoryInfos = [areaPkidArray]
    var areaPkidArray = ["全台", "臺北市", "新北市", "基隆市", "宜蘭縣", "桃園縣", "新竹縣", "新竹市",
                         "苗栗縣", "臺中市", "彰化縣", "南投縣","雲林縣", "嘉義縣", "嘉義市", "臺南市",
                         "高雄市", "屏東縣", "花蓮縣" ,"臺東縣", "澎湖縣" ,"金門縣", "連江縣"]
}

