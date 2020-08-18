//
//  SPHTech_AssignmentTests.swift
//  SPHTech_AssignmentTests
//
//  Created by Achsuthan Mahendran on 8/17/20.
//  Copyright © 2020 Achsuthan Mahendran. All rights reserved.
//

import XCTest
@testable import SPHTech_Assignment

class SPHTech_AssignmentTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //Intenet status variable checking
        let tmp = DataConsumptionViewModel()
        self.checkInternetStatus(tmp, false)
        
        //set it to true and check the variable
        tmp.setIsInternetFound(true)
        self.checkInternetStatus(tmp, true)
        
        //test success API Call
        self.successAPICallTest(tmp)
        self.failureAPICallTest1(tmp)
        self.failureAPICallTest2(tmp)
        
        self.testingOtherFunctionInViewController(tmp)

    }
    
    //Other functions
    func testingOtherFunctionInViewController(_ tmp: DataConsumptionViewModel){
        tmp.setConsummptionModelData(DataConsumptionModel(records: [Records(_id: 1, volume_of_mobile_data: "0.000384", quarter: "2004-Q3"), Records(_id: 2, volume_of_mobile_data: "0.000543", quarter: "2004-Q4"), Records(_id: 3, volume_of_mobile_data: "0.00062", quarter: "2005-Q1"), Records(_id: 4, volume_of_mobile_data: "0.000634", quarter: "2005-Q2"), Records(_id: 5, volume_of_mobile_data: "0.000718", quarter: "2005-Q3"), Records(_id: 6, volume_of_mobile_data: "0.000801", quarter: "2005-Q4"), Records(_id: 7, volume_of_mobile_data: "3.466228", quarter: "2011-Q1"), Records(_id: 8, volume_of_mobile_data: "3.380723", quarter: "2011-Q2"), Records(_id: 9, volume_of_mobile_data: "3.713792", quarter: "2011-Q3"), Records(_id: 10, volume_of_mobile_data: "4.07796", quarter: "2011-Q4") ], _links: Links(next: "")))
        
        //Test the no of cell
        XCTAssertEqual(tmp.getTotalRecordCount(), 3, "Check the number of cells")
        
        //check the single year with 3 indexs
        XCTAssertEqual(tmp.getSingleYear(0), "Year: 2004", "check single year 2004")
        XCTAssertEqual(tmp.getSingleYear(1), "Year: 2005", "check single year 2005")
        XCTAssertEqual(tmp.getSingleYear(2), "Year: 2011", "check single year 2011")
        
        //check the single year usage with 3 index
        XCTAssertEqual(tmp.getSingleUsage(0), "Usage: * Data for all 4 quarters not available", "check single year 2004 usage")
        XCTAssertEqual(tmp.getSingleUsage(1), "Usage: 0.000693", "check single year 2005 usage")
        XCTAssertEqual(tmp.getSingleUsage(2), "Usage: 3.659676", "check single year 2011 usage")
        
        //check the clickable image function
        XCTAssertEqual(tmp.isClickableImage(0), -1, "check single year 2004 click function")
        XCTAssertEqual(tmp.isClickableImage(1), -1, "check single year 2005 click function")
        XCTAssertEqual(tmp.isClickableImage(2), 2, "check single year 2011 click function")
    }
    
    //Initial it will be false
    func checkInternetStatus(_ tmp: DataConsumptionViewModel, _ status: Bool){
         XCTAssertEqual(tmp.getIsInternetFound(), status, "checkInternetStatus")
    }
    
    //success API call test
    func successAPICallTest(_ tmp: DataConsumptionViewModel){
        let url = NSURL(string: RequestUrls.getBaseUrl() + tmp.getPathUrl())!
        tmp.setPathUrl("/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=28")
        RequestUrls.getData = tmp.getPathUrl()
        let exp = expectation(description: "GET \(url)")
        UserHelper.callAPI(urlName: .getData, method: .get, parameters: [:]) { (status, result, error) in
            XCTAssert(status == true, "successAPICallTest")
            exp.fulfill()
        }
        waitForExpectations(timeout: 5){ error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //Failure API call test
    func failureAPICallTest1(_ tmp: DataConsumptionViewModel){
        let url = NSURL(string: RequestUrls.getBaseUrl() + tmp.getPathUrl())!
        tmp.setPathUrl("/api/action/datastore_search?ddresource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=28")
        let exp = expectation(description: "GET \(url)")
        RequestUrls.getData = tmp.getPathUrl()
        UserHelper.callAPI(urlName: .getData, method: .get, parameters: [:]) { (status, result, error) in
            XCTAssert(status == false, "failureAPICallTest")
            exp.fulfill()
        }
        waitForExpectations(timeout: 5){ error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //Failure API call test
    func getData(_ tmp: DataConsumptionViewModel){
        let url = NSURL(string: RequestUrls.getBaseUrl() + tmp.getPathUrl())!
        tmp.setPathUrl("/api/action/datastore_search?ddresource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=28")
        let exp = expectation(description: "GET \(url)")
        tmp.getData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("data", tmp.getTotalRecordCount())
            exp.fulfill()
        }
        waitForExpectations(timeout: 5){ error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //Failure API call test
    func failureAPICallTest2(_ tmp: DataConsumptionViewModel){
        let url = NSURL(string: RequestUrls.getBaseUrl() + tmp.getPathUrl())!
        tmp.setPathUrl("/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limittt=28")
        let exp = expectation(description: "GET \(url)")
        RequestUrls.getData = tmp.getPathUrl()
        UserHelper.callAPI(urlName: .getData, method: .get, parameters: [:]) { (status, result, error) in
            let response = result?.dictionaryObject!
            let success = response?["success"] as! Int
            XCTAssert(success == 0, "failureAPICallTest")
            exp.fulfill()
        }
        waitForExpectations(timeout: 5){ error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
