//
//  ViewController.swift
//  SPHTech_Assignment
//
//  Created by Achsuthan Mahendran on 8/17/20.
//  Copyright © 2020 Achsuthan Mahendran. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON
import Alamofire
import ObjectMapper

class UserHelper: HeaderHelper {
    
    static func callAPI(urlName: urlName, method: HttpMethod, parameters: [String:Any],completion: @escaping ((_ isSuccess: Bool, _ response: JSON?, _ error: AFError?) -> ())) {
        
        let tparameter = parameters
        
        var urlString = ""
        var Httpmethod: HTTPMethod = .get
        
        switch urlName {
        case .getData:
            urlString = RequestUrls.getData
            
            print("urlString \(urlString)")
            print("parameter",tparameter)
            print("method", method)
            
            switch method {
            case .get:
                Httpmethod = .get
            case .post:
                Httpmethod = .post
            case .put:
                Httpmethod = .put
            case .delete:
                Httpmethod = .delete
            }
            if tparameter.count > 0{
                Alamofire.request(urlString,method: Httpmethod, parameters: tparameter, encoding: JSONEncoding.default, headers: getCommonHeaders()).responseJSON { (dataResponse) in
                    if dataResponse.result.isSuccess {
                        let resultJSON = JSON(dataResponse.result.value!)
                        
                        print("result \(resultJSON)")
                        
                        if resultJSON["error"].stringValue  == "Unauthenticated." {
                            return
                        }
                        completion(true, resultJSON, nil)
                    } else {
                        return
                    }
                }
            }
            else{
                Alamofire.request(urlString,method: Httpmethod, parameters: nil, encoding: JSONEncoding.default, headers: getCommonHeaders()).responseJSON { (dataResponse) in
                    if dataResponse.result.isSuccess {
                        let resultJSON = JSON(dataResponse.result.value!)
                        
                        print("result \(resultJSON)")
                        
                        if resultJSON["error"].stringValue  == "Unauthenticated." {
                            return
                        }
                        completion(true, resultJSON, nil)
                    } else {
                        print("something wrong")
                        completion(false, nil, nil)
                    }
                }
            }
        }
    }
}

enum HttpMethod {
    case get, post, delete, put
}

enum urlName {
    case getData
}

