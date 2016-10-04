//
//  MainTableViewCell.swift
//  BubbleTeaFinder
//
//  Created by alex on 17/09/16.
//  Copyright © 2016 alex. All rights reserved.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {
    
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
        SystemLabel.labelWithSystemFont(mainTextLabel, fontSize: 18, textColor: UIColor.blackColor())
        SystemLabel.labelWithSystemFont(detailedTextLabel, fontSize: 18, textColor: UIColor.grayColor(), textAligment: .Right)
        
        // add to view
        contentView.addSubview(mainTextLabel)
        contentView.addSubview(detailedTextLabel)

        // place
        mainTextLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(0)
            make.left.equalTo(15)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        detailedTextLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(0)
            make.right.equalTo(-10)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
    }
}
