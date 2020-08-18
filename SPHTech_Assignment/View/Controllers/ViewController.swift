//
//  ViewController.swift
//  SPHTech_Assignment
//
//  Created by Achsuthan Mahendran on 8/17/20.
//  Copyright © 2020 Achsuthan Mahendran. All rights reserved.
//

import UIKit
import Reachability

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, dataConsumtionImagclick, SuccessGetData {
    func getSuccessData() {
        self.dataConsumptionTableView.reloadData()
    }
    
    func imageClick(_ index: Int) {
        let alert = UIAlertController(title: "Alert", message: "Drop in \(self.dataConsumptionViewModel.getSingleYear(index))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataConsumptionViewModel.getTotalRecordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view  = tableView.dequeueReusableCell(withIdentifier: "dataConsumptionTableViewTableViewCell", for: indexPath) as! dataConsumptionTableViewTableViewCell
        view.selectionStyle = .none
        view.delegate = self
        view.index = self.dataConsumptionViewModel.isClickableImage(indexPath.row)
        view.lblYear.text = self.dataConsumptionViewModel.getSingleYear(indexPath.row)
        view.lblDataUsage.text = self.dataConsumptionViewModel.getSingleUsage(indexPath.row)
        view.lblDataUsage.textColor = self.dataConsumptionViewModel.getSingleUsage(indexPath.row) == "Usage: * Data for all 4 quarters not available" ? UIColor.red : UIColor.black
        return view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == dataConsumptionTableView {
            for cell in dataConsumptionTableView.visibleCells {
                let indexPath = dataConsumptionTableView.indexPath(for: cell)
                if self.dataConsumptionViewModel.needToCallAPI(indexPath?.row ?? 0) && self.dataConsumptionViewModel.getTotalRecordCount() > 0 && self.dataConsumptionViewModel.getIsInternetFound(){
                    if self.dataConsumptionViewModel.getNextUrl() != "" {
                        self.dataConsumptionViewModel.setPathUrl(self.dataConsumptionViewModel.getNextUrl())
                        self.dataConsumptionViewModel.delegate = self
                        self.dataConsumptionViewModel.getData()
                    }
                }
            }
            
        }
    }
    
    
    let dataConsumptionTableView: UITableView = {
        let tabel = UITableView()
        tabel.translatesAutoresizingMaskIntoConstraints = false
        tabel.separatorStyle = .none
        return tabel
    }()
    
    var dataConsumptionViewModel = DataConsumptionViewModel()
    var reachability: Reachability!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    private func setUp(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.dataConsumptionTableView)
        self.dataConsumptionTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.dataConsumptionTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.dataConsumptionTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.dataConsumptionTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.dataConsumptionTableView.delegate = self
        self.dataConsumptionTableView.dataSource = self
        self.dataConsumptionTableView.register(dataConsumptionTableViewTableViewCell.self, forCellReuseIdentifier: "dataConsumptionTableViewTableViewCell")
        
        do {
            try reachability = Reachability()
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
            try reachability.startNotifier()
        } catch {
            print("This is not working.")
        }
    }
    
    @objc func reachabilityChanged(_ note: NSNotification) {
        let reachability = note.object as! Reachability
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if reachability.connection != .unavailable {
            self.dataConsumptionViewModel.delegate = self
            let previousState = self.dataConsumptionViewModel.getIsInternetFound()
            if !previousState {
                if self.dataConsumptionViewModel.getTotalRecordCount() > 0 {
                    appDelegate.showToasterMessage("You are live now, trying to featch the latest data....")
                }
                self.dataConsumptionViewModel.setIsInternetFound(true)
                self.dataConsumptionViewModel.setIsCallAPI(true)
                self.dataConsumptionViewModel.getData()
            }
        } else {
            self.dataConsumptionViewModel.delegate = self
            self.dataConsumptionViewModel.setIsInternetFound(false)
            self.dataConsumptionViewModel.setPathUrl("/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=28")
            self.dataConsumptionViewModel.setIsCallAPI(false)
            appDelegate.showToasterMessage("Please check your internet connection, cashe data will be display")
            print("Not reachable")
        }
    }
    
    
}

