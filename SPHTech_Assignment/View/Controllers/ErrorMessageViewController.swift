//
//  ErrorMessageViewController.swift
//  SPHTech_Assignment
//
//  Created by Achsuthan Mahendran on 8/18/20.
//  Copyright © 2020 Achsuthan Mahendran. All rights reserved.
//

import UIKit

class ErrorMessageViewController: UIViewController {
    
    let messageView: UIView = {
        let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let lbldetails: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Testing testing"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    var message: String = "" {
        didSet{
            self.lbldetails.text = self.message
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    private func setUp(){
        self.view.backgroundColor = .clear
        self.view.addSubview(self.messageView)
        self.messageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        self.messageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        self.messageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        self.messageView.layer.cornerRadius = 10
        
        self.messageView.addSubview(self.lbldetails)
        self.lbldetails.topAnchor.constraint(equalTo: self.messageView.topAnchor, constant: 10).isActive = true
        self.lbldetails.leadingAnchor.constraint(equalTo: self.messageView.leadingAnchor, constant: 10).isActive = true
        self.lbldetails.trailingAnchor.constraint(equalTo: self.messageView.trailingAnchor, constant: -10).isActive = true
        self.lbldetails.bottomAnchor.constraint(equalTo: self.messageView.bottomAnchor, constant: -10).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: false, completion: nil)
        }
    }

}
