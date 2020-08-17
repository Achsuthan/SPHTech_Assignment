//
//  ViewController.swift
//  SPHTech_Assignment
//
//  Created by Achsuthan Mahendran on 8/17/20.
//  Copyright © 2020 Achsuthan Mahendran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, dataConsumtionImagclick, SuccessGetData {
    func getSuccessData() {
        self.dataConsumptionTableView.reloadData()
    }
    
    func imageClick(_ index: Int) {
        print("index", index)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataConsumptionViewModel.getTotalRecordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view  = tableView.dequeueReusableCell(withIdentifier: "dataConsumptionTableViewTableViewCell", for: indexPath) as! dataConsumptionTableViewTableViewCell
        view.selectionStyle = .none
        view.delegate = self
        view.index = indexPath.row
        view.lblYear.text = self.dataConsumptionViewModel.getSingleYear(indexPath.row)
        view.lblDataUsage.text = self.dataConsumptionViewModel.getSingleUsage(indexPath.row)
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.dataConsumptionViewModel.needToCallAPI(indexPath.row){
            if self.dataConsumptionViewModel.getNextUrl() != "" {
                self.dataConsumptionViewModel.setPathUrl(self.dataConsumptionViewModel.getNextUrl())
                self.dataConsumptionViewModel.delegate = self
                self.dataConsumptionViewModel.getData()
            }
        }
    }
    
    
    let dataConsumptionTableView: UITableView = {
        let tabel = UITableView()
        tabel.translatesAutoresizingMaskIntoConstraints = false
        return tabel
    }()
    
    var dataConsumptionViewModel = DataConsumptionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    private func setUp(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.dataConsumptionTableView)
        self.dataConsumptionTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.dataConsumptionTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.dataConsumptionTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.dataConsumptionTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.dataConsumptionTableView.delegate = self
        self.dataConsumptionTableView.dataSource = self
        self.dataConsumptionTableView.register(dataConsumptionTableViewTableViewCell.self, forCellReuseIdentifier: "dataConsumptionTableViewTableViewCell")
        self.dataConsumptionViewModel.setIsCallAPI(true)
        self.dataConsumptionViewModel.getData()
        self.dataConsumptionViewModel.delegate = self
    }


}

