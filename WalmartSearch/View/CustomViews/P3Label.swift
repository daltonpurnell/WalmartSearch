//
//  P3Label.swift
//  WalmartSearch
//
//  Created by Dalton on 5/13/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import UIKit

class P3Label: UILabel {
    
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
        self.font = Constants.Fonts.p3
    }
}
