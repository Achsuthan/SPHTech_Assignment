//
//  File.swift
//  SPHTech_Assignment
//
//  Created by Achsuthan Mahendran on 8/17/20.
//  Copyright © 2020 Achsuthan Mahendran. All rights reserved.
//

import Foundation

//Image click event
protocol dataConsumtionImagclick {
    func imageClick(_ index: Int)
}

//API call success from ViewModel to Controller
protocol SuccessGetData {
    func getSuccessData()
}
