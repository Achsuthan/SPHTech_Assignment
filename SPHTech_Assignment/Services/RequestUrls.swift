//
//  ViewController.swift
//  SPHTech_Assignment
//
//  Created by Achsuthan Mahendran on 8/17/20.
//  Copyright © 2020 Achsuthan Mahendran. All rights reserved.
//

import Foundation

private var port: String = "dev"

struct RequestUrls {
    //URLs
    private static var sandboxUrl = "https://data.gov.sg" //Client
    private static var liveUrl = ""
    
    public static func getBaseUrlStatus() -> String{
        return port
    }
    
    public static func getBaseUrl() -> String {
        switch port {
        case "dev":
            return sandboxUrl
        case "live":
            return liveUrl
        default:
            return sandboxUrl
        }
    }
    
    static var getDataUrl = "/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=20"
    
    static var getData: String {
        get {
            return getBaseUrl() + getDataUrl
        }
        set {
            getDataUrl = newValue
        }
    }
    
}

