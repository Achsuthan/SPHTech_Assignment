//
//  DataConsumptionViewModel.swift
//  SPHTech_Assignment
//
//  Created by Achsuthan Mahendran on 8/17/20.
//  Copyright © 2020 Achsuthan Mahendran. All rights reserved.
//

import Foundation


class DataConsumptionViewModel {
    private var pathUrl = "/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=20"
    private var consumtionModel = DataConsumptionModel(records: [], _links: Links(next: ""), total: 0)
    private var isCallAPI: Bool = false
    var delegate: SuccessGetData!
    
    //Setters
    public func setPathUrl(_ data: String){
        self.pathUrl = data
    }
    
    public func setIsCallAPI(_ data: Bool){
        self.isCallAPI = data
    }
    
    public func getNextUrl()-> String{
        return self.consumtionModel._links.next ?? ""
    }
    
    
    //Getters
    public func getPathUrl()-> String{
        return pathUrl
    }
    
    public func getTotalRecordCount()-> Int{
        return self.consumtionModel.records.count
    }
    
    public func getSingleUsage(_ index: Int)-> String{
        return self.consumtionModel.records[index].volume_of_mobile_data
    }
    
    public func getSingleYear(_ index: Int)->String{
        return self.consumtionModel.records[index].quarter
    }
    
    public func needToCallAPI(_ currentIndex: Int)-> Bool{
        return currentIndex >= self.consumtionModel.records.count - 1 && isCallAPI
    }
    
    public func isCallAPIFn()-> Bool{
        return isCallAPI
    }
    
    
    
    //API calls
    public func getData(){
        if isCallAPI {
            RequestUrls.getData = pathUrl
            UserHelper.callAPI(urlName: .getData, method: .get, parameters: [:]) { (status, result, error) in
                if status {
                    let response = result?.dictionaryObject!
                    let success = response?["success"] as! Int
                    if success == 1 {
                        self.isCallAPI = true
                        print("success")
                        if let jsonData = try? JSONEncoder().encode(result!["result"] ),
                            let jsonString = String(data: jsonData, encoding: .utf8) {
                            if let data = jsonString.data(using: .utf8),
                                let dataConsumption = try? JSONDecoder().decode(DataConsumptionModel.self, from: data) {
                                self.consumtionModel.records.append(contentsOf: dataConsumption.records)
                                self.consumtionModel._links = dataConsumption._links
                                if dataConsumption.records.count == 0 {
                                    self.isCallAPI = false
                                }
                                self.delegate.getSuccessData()
                            }
                        }
                    }
                    else {
                        self.isCallAPI = true
                        print("failed")
                    }
                }
                else {
                    self.isCallAPI = true
                }
            }
        }
        
    }
    
}
