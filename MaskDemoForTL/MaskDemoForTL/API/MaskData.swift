//
//  MaskData.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import Foundation

// MARK: - MaskData
struct MaskData: Codable, RowViewModel {
    let type: String
    let features: [Feature]
}

// MARK: - Feature
struct Feature: Codable, RowViewModel {
    let type: String
    let properties: Properties
    let geometry: Geometry
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

// MARK: - Properties
struct Properties: Codable {
    let id, name, phone, address: String
    let maskAdult, maskChild: Int
    let updated, available, note, customNote: String
    let website, county, town, cunli: String
    let servicePeriods: String

    enum CodingKeys: String, CodingKey {
        case id, name, phone, address
        case maskAdult = "mask_adult"
        case maskChild = "mask_child"
        case updated, available, note
        case customNote = "custom_note"
        case website, county, town, cunli
        case servicePeriods = "service_periods"
    }
}
