//
//  DataConsumptionModel.swift
//  SPHTech_Assignment
//
//  Created by Achsuthan Mahendran on 8/17/20.
//  Copyright © 2020 Achsuthan Mahendran. All rights reserved.
//

import Foundation

struct DataConsumptionModel:Codable {
    var records: [Records]
    var _links: Links
    var offset: Int? = 0
}

struct Records:Codable {
    var _id: Int
    var volume_of_mobile_data: String
    var quarter: String
}

struct Links:Codable {
    var next: String?
}

struct YearDataConsumption {
    var year: String
    var usage: Double
    var usageArrayForYearQuarter: [Double]
}
