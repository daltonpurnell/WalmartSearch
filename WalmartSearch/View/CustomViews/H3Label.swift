//
//  H3Label.swift
//  WalmartSearch
//
//  Created by Dalton on 5/14/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import UIKit

class H3Label: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.customInit()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    fileprivate func customInit() {
        addProperties()
    }
    
    fileprivate func addProperties() {
        self.textColor = Constants.Colors.darkBlue
        self.font = Constants.Fonts.h3
    }
}
