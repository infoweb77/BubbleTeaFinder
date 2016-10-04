//
//  FilterTableViewCell.swift
//  BubbleTeaFinder
//
//  Created by alex on 21/09/16.
//  Copyright © 2016 alex. All rights reserved.
//

import UIKit
import SnapKit

class FilterTableViewCell: UITableViewCell {
    
    let mainTextLabel = UILabel()
    let detailedTextLabel = UILabel()
    
    // initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // setup
    func setupViews() {
        // configure
        SystemLabel.labelWithSystemFont(mainTextLabel, fontSize: 15, textColor: UIColor.blackColor())
        SystemLabel.labelWithSystemFont(detailedTextLabel, fontSize: 13, textColor: UIColor.grayColor())
        
        // add to view
        contentView.addSubview(mainTextLabel)
        contentView.addSubview(detailedTextLabel)
        
        // place
        mainTextLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(4)
            make.left.equalTo(15)
            make.width.equalTo(250)
            make.height.equalTo(18)
        }
        
        detailedTextLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(27)
            make.left.width.equalTo(mainTextLabel)
            make.height.equalTo(15)
        }
    }
}

