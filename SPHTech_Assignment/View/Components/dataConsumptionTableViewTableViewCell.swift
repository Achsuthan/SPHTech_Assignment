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
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
        view.backgroundColor = .white
        return view
    }()
    
    let lblYear: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Year: 2020"
        label.numberOfLines = 0
        return label
    }()
    
    let lblDataUsage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Usage: 0.23232"
        label.numberOfLines = 0
        return label
    }()
    
    let img: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "viewMore")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var delegate: dataConsumtionImagclick!
    var index: Int = 0 {
        didSet{
            DispatchQueue.main.async {
                if self.index > -1 {
                    self.img.alpha = 1
                }
                else {
                    self.img.alpha = 0
                }
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
        self.viewBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.viewBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.viewBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.viewBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.viewBackground.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        self.viewBackground.addSubview(self.img)
        self.img.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.img.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.img.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        self.img.heightAnchor.constraint(equalToConstant:220).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imgClicked(gesture:)))
        img.addGestureRecognizer(tapGesture)
        img.isUserInteractionEnabled = true
        
        self.viewBackground.addSubview(self.lblYear)
        self.lblYear.topAnchor.constraint(equalTo: self.img.bottomAnchor, constant: 10).isActive = true
        self.lblYear.leadingAnchor.constraint(equalTo: self.viewBackground.leadingAnchor, constant: 10).isActive = true
        self.lblYear.trailingAnchor.constraint(equalTo: self.viewBackground.trailingAnchor, constant: -10).isActive = true
        
        self.viewBackground.addSubview(self.lblDataUsage)
        self.lblDataUsage.topAnchor.constraint(equalTo: self.lblYear.bottomAnchor, constant: 10).isActive = true
        self.lblDataUsage.leadingAnchor.constraint(equalTo: self.viewBackground.leadingAnchor, constant: 10).isActive = true
        self.lblDataUsage.trailingAnchor.constraint(equalTo: self.viewBackground.trailingAnchor, constant: -10).isActive = true
        self.lblDataUsage.bottomAnchor.constraint(equalTo: self.viewBackground.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func imgClicked(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            self.delegate.imageClick(self.index)
        }
    }
}
