//
//  File.swift
//  WalmartSearch
//
//  Created by Dalton on 5/12/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Keys {
        static let walmartOpenApiKey:String = "b68mqfez5xhjrqyf9ytv4z96"
    }
    
    struct Urls {
        static let baseUrl:String = "http://api.walmartlabs.com"
    }
    
    struct Paths {
        static let lookupPath:String = "/v1/items"
        static let searchPath:String = "/v1/search"
        static let recommendationsPath:String = "/v1/nbp"
        static let trendingPath:String = "/v1/trends"
    }
    
    struct Fonts {
        static let h1:UIFont? = UIFont(name: "Bogle-Black", size: 22)
        static let h2:UIFont? = UIFont(name: "Bogle-Bold", size: 18)
        static let h3:UIFont? = UIFont(name: "Bogle-Bold", size: 14)
        static let p1:UIFont? = UIFont(name: "Bogle-Regular", size: 14)
        static let p2:UIFont? = UIFont(name: "Bogle-Regular", size: 12)
        static let p3:UIFont? = UIFont(name: "Bogle-Regular", size: 10)
    }
    
    struct Colors {
        static let walmartBlue:UIColor = UIColor(red: 0.0/255.0, green: 113.0/255.0, blue: 206.0/255.0, alpha: 1)
        static let sparkYellow:UIColor = UIColor(red: 255.0/255.0, green: 194.0/255.0, blue: 32.0/255.0, alpha: 1)
        static let darkBlue:UIColor = UIColor(red: 4.0/255.0, green: 30.0/255.0, blue: 66.0/255.0, alpha: 1)
        static let marketGreen:UIColor = UIColor(red: 95.0/255.0, green: 180.0/255.0, blue: 70.0/255.0, alpha: 1)
        static let rollbackRed:UIColor = UIColor(red: 222.0/255.0, green: 28.0/255.0, blue: 36.0/255.0, alpha: 1)

        static let lightGray:UIColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1)
    }
}
