//
//  SystemLabel.swift
//  BubbleTeaFinder
//
//  Created by alex on 17/09/16.
//  Copyright © 2016 alex. All rights reserved.
//

import UIKit

class SystemLabel {
    
    class func labelWithSystemFont(label: UILabel, fontSize: CGFloat, textColor: UIColor, textAligment: NSTextAlignment = .Left) {
        let fontRegular = UIFont.init(name: "HelveticaNeue", size: fontSize)
        return self.configureLabelWithFont(label, font: fontRegular!, textColor: textColor, textAligment: textAligment)
    }
    
    class func labelWithBoldSystemFont(label: UILabel, fontSize: CGFloat, textColor: UIColor, textAligment: NSTextAlignment = .Left) {
        let fontBold = UIFont.init(name: "HelveticaNeue-Bold", size: fontSize)
        return self.configureLabelWithFont(label, font: fontBold!, textColor: textColor, textAligment: textAligment)
    }
    
    class func labelWithMediumSystemFont(label: UILabel, fontSize: CGFloat, textColor: UIColor, textAligment: NSTextAlignment = .Left) {
        let fontMedium = UIFont.init(name: "HelveticaNeue-Medium", size: fontSize)
        return self.configureLabelWithFont(label, font: fontMedium!, textColor: textColor, textAligment: textAligment)
    }
    
    class func labelForSystem() -> UILabel {
        let label = UILabel()
        let fontSystem = UIFont.init(name: "HelveticaNeue", size: 15)
        self.configureLabelWithFont(label, font: fontSystem!, textColor: UIColor.darkGrayColor(), textAligment: .Center)
        return label
    }
    
    class func configureLabelWithFont(label: UILabel, font: UIFont, textColor: UIColor, textAligment: NSTextAlignment = .Left) {
        label.numberOfLines = 0
        label.lineBreakMode = .ByClipping
        label.textColor = textColor
        label.font = font
        label.textAlignment = textAligment
    }
}
