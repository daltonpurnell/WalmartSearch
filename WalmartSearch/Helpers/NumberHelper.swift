//
//  NumberFormatter.swift
//  WalmartSearch
//
//  Created by Dalton on 5/15/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import Foundation

class NumberHelpter {
    class func formatDouble(double:Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let number:NSNumber = NSNumber(floatLiteral: double)
        var numberString:String = formatter.string(from: number)!
        if numberString.starts(with: ".") {
            numberString = "0\(numberString)"
        }
        return numberString
    }
}

