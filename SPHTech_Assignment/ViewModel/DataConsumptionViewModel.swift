//
//  DataConsumptionViewModel.swift
//  SPHTech_Assignment
//
//  Created by Achsuthan Mahendran on 8/17/20.
//  Copyright © 2020 Achsuthan Mahendran. All rights reserved.
//

import UIKit
import CoreData


class DataConsumptionViewModel {
    private var pathUrl = "/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=28"
    private var consummptionModel = DataConsumptionModel(records: [], _links: Links(next: ""))
    private var yearConsumption:[YearDataConsumption] = [YearDataConsumption]()
    
    private var backupConsummptionModel = DataConsumptionModel(records: [], _links: Links(next: ""))
    private var isCallAPI: Bool = false
    
    private var isInternetFound: Bool = false
    var delegate: SuccessGetData?
    
    
    //Setters
    //set the path url
    public func setPathUrl(_ data: String){
        self.pathUrl = data
    }
    //set wather API can call or not
    public func setIsCallAPI(_ data: Bool){
        self.isCallAPI = data
    }
    //Get the next link from API response
    public func getNextUrl()-> String{
        return self.consummptionModel._links.next ?? ""
    }
    //Function to handle the internet is aviable or not
    //If not avialable the core data details will be assgined to private variable
    //Other wise clear the data from core data
    public func setIsInternetFound(_ data: Bool){
        self.isInternetFound = data
        if !data {
            self.getAllRecords()
            self.consummptionModel = self.backupConsummptionModel
            self.createYearConsumptionArray()
        }
        else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "DataConsumptionRecord")
            let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
            do { try context.execute(DelAllReqVar) }
            catch { print(error) }
            self.consummptionModel = DataConsumptionModel(records: [], _links: Links(next: ""))
        }
    }
    //Fucntion is used to create the Year basis array
    public func createYearConsumptionArray(){
        yearConsumption = []
        let tmp = Dictionary(grouping: consummptionModel.records, by: {Int($0.quarter.split(separator: "-")[0]) ?? 0}).sorted{$0.key < $1.key}
        for (key, value) in tmp {
            var usage = 0.0
            var quarterArray:[Double] = []
            let _ = value.enumerated().map{(index, element) in
                usage += Double(element.volume_of_mobile_data) ?? 0.0
                quarterArray.append(Double(element.volume_of_mobile_data) ?? 0.0)
            }
            yearConsumption.append(YearDataConsumption(year: "\(key)", usage: usage, usageArrayForYearQuarter: quarterArray))
        }
        self.delegate?.getSuccessData()
    }
    
    #if DEBUG
    //use this function only for testing purpose
    public func setConsummptionModelData(_ data: DataConsumptionModel){
        self.consummptionModel = data
        self.createYearConsumptionArray()
    }
    #endif
    
    
    //Getters
    //Get the path URL
    public func getPathUrl()-> String{
        return pathUrl
    }
    //Get the total number of year from the API resonse which is used to show how many number of rows in a table view
    public func getTotalRecordCount()-> Int{
        return self.yearConsumption.count
    }
    
    //Get the single usage details based on the index
    public func getSingleUsage(_ index: Int)-> String{
        return "Usage: \(self.yearConsumption[index].usageArrayForYearQuarter.count == 4 ? "\(String(format: "%.6f", self.yearConsumption[index].usageArrayForYearQuarter.reduce(0, {sum, number in sum + number})/4))" : "* Data for all 4 quarters not available")"
    }
    //Get the single year details based on the index
    public func getSingleYear(_ index: Int)->String{
        return "Year: \(self.yearConsumption[index].year)"
    }
    
    //Function is used to check any drops in a year if yes return the current index otherwise -1
    public func isClickableImage(_ index: Int)-> Int {
        let tmp = self.yearConsumption[index].usageArrayForYearQuarter
        if tmp.count != 4 {
            return -1
        }
        var found  = false
        let _ = tmp.enumerated().map{(index, element) in
            if index > 0 {
                for val in 0...index{
                    if tmp[val] > element{
                        found = true
                        break
                    }
                }
            }
        }
        
        return found ? index : -1
        
    }
    //pagination handler function
    public func needToCallAPI(_ currentIndex: Int)-> Bool{
        return currentIndex >= self.yearConsumption.count - 1 && isCallAPI
    }
    //Used to ge the API can call or not
    public func isCallAPIFn()-> Bool{
        return isCallAPI
    }
    //Get internet is avilable or not
    public func getIsInternetFound()-> Bool{
        return self.isInternetFound
    }
    
    //Core Data add the data to entity
    func addRecordsData(_ records:[Records]){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "DataConsumptionRecord", in: context) else {
            fatalError("could not find entity description!")
        }
        
        
        for val in records {
            let newRecored = NSManagedObject(entity: entity, insertInto: context)
            newRecored.setValue(val._id, forKey: "id")
            newRecored.setValue(val.quarter, forKey: "quarter")
            newRecored.setValue(val.volume_of_mobile_data, forKey: "volume_of_mobile_data")
            do {
                try context.save()
            } catch{
                print("Failed to save the data")
            }
        }
        self.getAllRecords()
    }
    
    //getdata from Core data
    public func getAllRecords(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DataConsumptionRecord")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var tmp = DataConsumptionModel(records: [], _links: Links(next: ""))
            for data in result as! [NSManagedObject] {
                tmp.records.append(Records(_id: data.value(forKey: "id") as! Int, volume_of_mobile_data: data.value(forKey: "volume_of_mobile_data") as! String, quarter: data.value(forKey: "quarter") as! String))
            }
            self.backupConsummptionModel = tmp
            
        } catch {
            print("Failed")
        }
    }
    
    //API calls
    public func getData(){
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if isCallAPI {
            self.isCallAPI = false
            RequestUrls.getData = pathUrl
            UserHelper.callAPI(urlName: .getData, method: .get, parameters: [:]) { (status, result, error) in
                if status {
                    let response = result?.dictionaryObject!
                    let success = response?["success"] as! Int
                    if success == 1 {
                        self.isCallAPI = true
                        if let jsonData = try? JSONEncoder().encode(result!["result"] ),
                            let jsonString = String(data: jsonData, encoding: .utf8) {
                            if let data = jsonString.data(using: .utf8),
                                let dataConsumption = try? JSONDecoder().decode(DataConsumptionModel.self, from: data) {
                                self.consummptionModel.records.append(contentsOf: dataConsumption.records)
                                self.consummptionModel._links = dataConsumption._links
                                if dataConsumption.records.count == 0 {
                                    self.isCallAPI = false
                                }
                                else {
                                    self.addRecordsData(dataConsumption.records)
                                }
                                self.createYearConsumptionArray()
                            }
                        }
                    }
                    else {
                        self.isCallAPI = true
                        let error  = response?["error"] as? [String: Any]
                        appDelegate.showToasterMessage(error?["__type"] as? String ?? "Something went wrong, try restarting the app few minutes")
                        
                    }
                }
                else {
                    self.isCallAPI = true
                    appDelegate.showToasterMessage("Something went wrong, try restarting the app few minutes")
                }
            }
        }
        
    }
    
}
