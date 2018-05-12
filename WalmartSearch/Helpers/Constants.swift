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
    }
}
