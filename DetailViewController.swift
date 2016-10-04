//
//  DetailViewController.swift
//  BubbleTeaFinder
//
//  Created by alex on 17/09/16.
//  Copyright © 2016 alex. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var currentShop: Shop!
    
    // MARK - ViewController lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(shop: Shop) {
        super.init(nibName: nil, bundle: nil)
        currentShop = shop
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        
        setupNavigation()
        setupViews()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Shop Info"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(backPerformAction(_:)))
    }
    
    @objc func backPerformAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setupViews() {
        
        let darkGray = UIColor.darkGrayColor()
        let center = NSTextAlignment.Center
        
        // setup
        let nameLabel = UILabel()
        SystemLabel.labelWithBoldSystemFont(nameLabel, fontSize: 18, textColor: darkGray, textAligment: center)
        nameLabel.text = currentShop.name
        
        let phoneLabel = UILabel()
        SystemLabel.labelWithMediumSystemFont(phoneLabel, fontSize: 15, textColor: darkGray, textAligment: center)
        let phone = currentShop.phone
        phoneLabel.text = (phone != nil) ? "Phone: \(phone!)" : " "
        
        // address
        let addressLabel = SystemLabel.labelForSystem()
        let addr = currentShop.location?.address
        addressLabel.text = "Address: " + ((addr != nil) ? "\(addr!)" : "")
        
        let address2Label = SystemLabel.labelForSystem()
        let cross = currentShop.location?.crossStreet
        let city = currentShop.location?.city
        address2Label.text = (cross != "") ? "\(cross!), \(city!)" : "\(city!)"
        
        // location
        let latLabel = SystemLabel.labelForSystem()
        let lat = currentShop.location?.lat
        latLabel.text = "Latitude: \(lat!)"
        
        let lonLabel = SystemLabel.labelForSystem()
        let lng = currentShop.location?.lng
        lonLabel.text = "Longitude: \(lng!)"
        
        let distLabel = SystemLabel.labelForSystem()
        let dist = currentShop.location?.distance
        distLabel.text = "Distance - \(dist!) m"
        
        
        let tipsLabel = SystemLabel.labelForSystem()
        let tipCount = currentShop.stats?.tipCount
        tipsLabel.text = "Tips Count: \(tipCount!)"
        
        let specLabel = SystemLabel.labelForSystem()
        let special = currentShop.specialCount
        specLabel.text = "Special Count: \(special!)"
        
        
        // add to view
        view.addSubview(nameLabel)
        view.addSubview(phoneLabel)
        view.addSubview(addressLabel)
        view.addSubview(address2Label)
        
        view.addSubview(latLabel)
        view.addSubview(lonLabel)
        view.addSubview(distLabel)
        
        view.addSubview(tipsLabel)
        view.addSubview(specLabel)
        
        
        // place
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(95)
            make.centerX.equalTo(0)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        phoneLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(140)
            make.centerX.width.equalTo(nameLabel)
            make.height.equalTo(18)
        }
        
        addressLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(185)
            make.centerX.height.equalTo(phoneLabel)
            make.width.equalTo(350)
        }
        
        address2Label.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(210)
            make.centerX.height.width.equalTo(addressLabel)
        }
        
        
        latLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(260)
            make.centerX.height.width.equalTo(addressLabel)
        }
        
        lonLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(282)
            make.centerX.height.width.equalTo(addressLabel)
        }
        
        distLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(304)
            make.centerX.height.width.equalTo(addressLabel)
        }
        
        
        tipsLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(355)
            make.centerX.height.width.equalTo(addressLabel)
        }
        
        specLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(385)
            make.centerX.height.width.equalTo(addressLabel)
        }
        
    }
}

