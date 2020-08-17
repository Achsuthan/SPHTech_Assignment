//
//  dataConsumptionTableViewTableViewCell.swift
//  SPHTech_Assignment
//
//  Created by Achsuthan Mahendran on 8/17/20.
//  Copyright © 2020 Achsuthan Mahendran. All rights reserved.
//

import UIKit

class dataConsumptionTableViewTableViewCell: UITableViewCell {
    
    let viewBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblYear: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Year: 2020"
        return label
    }()
    
    let lblDataUsage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Usage: 0.23232"
        return label
    }()
    
    let img: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "select")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var delegate: dataConsumtionImagclick!
    var index: Int = 0 {
        didSet{
            if self.index > -1 {
                self.img.alpha = 1
            }
            else {
                self.img.alpha = 0
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(){
        self.addSubview(self.viewBackground)
        self.viewBackground.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.viewBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.viewBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.viewBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.viewBackground.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        self.viewBackground.addSubview(self.img)
        self.img.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        self.img.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.img.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.img.centerYAnchor.constraint(equalTo: self.viewBackground.centerYAnchor).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imgClicked(gesture:)))
        img.addGestureRecognizer(tapGesture)
        img.isUserInteractionEnabled = true
        
        self.viewBackground.addSubview(self.lblYear)
        self.lblYear.topAnchor.constraint(equalTo: self.viewBackground.topAnchor, constant: 10).isActive = true
        self.lblYear.leadingAnchor.constraint(equalTo: self.viewBackground.leadingAnchor, constant: 10).isActive = true
        self.lblYear.trailingAnchor.constraint(equalTo: self.img.trailingAnchor, constant: -10).isActive = true
        
        self.viewBackground.addSubview(self.lblDataUsage)
        self.lblDataUsage.topAnchor.constraint(equalTo: self.lblYear.bottomAnchor, constant: 10).isActive = true
        self.lblDataUsage.leadingAnchor.constraint(equalTo: self.viewBackground.leadingAnchor, constant: 10).isActive = true
        self.lblDataUsage.trailingAnchor.constraint(equalTo: self.img.trailingAnchor, constant: -10).isActive = true
        self.lblDataUsage.bottomAnchor.constraint(equalTo: self.viewBackground.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func imgClicked(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            self.delegate.imageClick(self.index)
        }
    }
}
