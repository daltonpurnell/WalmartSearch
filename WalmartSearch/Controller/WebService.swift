//
//  WebService.swift
//  WalmartSearch
//
//  Created by Dalton on 5/12/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import Foundation

class WebService {
    
    typealias JSONDictionary = [String: Any]
    typealias ProductResult = ([Product]?, String) -> ()
    typealias ProductDetailsResult = (ProductDetails?, String) -> ()
    
    var searchResults:[Product] = []
    var recommendationsResults:[Product] = []
    var productDetailsResults:ProductDetails?
    var trendingResults:[Product] = []
    var errorMessage = ""
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getSearchResults(searchTerm: String, completion: @escaping ProductResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: Constants.Urls.baseUrl) {
            urlComponents.path = Constants.Paths.searchPath
            urlComponents.query = "apiKey=\(Constants.Keys.walmartOpenApiKey)&query=\(searchTerm)&sort=price&order=asc"
            guard let url = urlComponents.url else {
                return
            }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.mapResponse(data, isMappingTrendingResults: false)
                    DispatchQueue.main.async {
                        completion(self.searchResults, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func getRecommendations(itemId: Int, completion: @escaping ProductResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: Constants.Urls.baseUrl) {
            urlComponents.path = Constants.Paths.recommendationsPath
            urlComponents.query = "apiKey=\(Constants.Keys.walmartOpenApiKey)&itemId=\(itemId)&order=asc"
            guard let url = urlComponents.url else {
                return
            }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.mapRecommendationsResponse(data)
                    DispatchQueue.main.async {
                        completion(self.recommendationsResults, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func getTrendingProducts(completion: @escaping ProductResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: Constants.Urls.baseUrl) {
            urlComponents.path = Constants.Paths.trendingPath
            urlComponents.query = "apiKey=\(Constants.Keys.walmartOpenApiKey)"
            guard let url = urlComponents.url else {
                return
            }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.mapResponse(data, isMappingTrendingResults: true)
                    DispatchQueue.main.async {
                        completion(self.trendingResults, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func getProductDetails(itemId: Int, completion: @escaping ProductDetailsResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: Constants.Urls.baseUrl) {
            urlComponents.path = "\(Constants.Paths.lookupPath)/\(itemId)"
            urlComponents.query = "apiKey=\(Constants.Keys.walmartOpenApiKey)"
            guard let url = urlComponents.url else {
                return
            }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.mapDetailsResponse(data)
                    DispatchQueue.main.async {
                        completion(self.productDetailsResults, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    fileprivate func mapResponse(_ data: Data, isMappingTrendingResults: Bool) {
        var response: JSONDictionary?
        isMappingTrendingResults ? trendingResults.removeAll() : searchResults.removeAll()

        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["items"] as? [Any] else {
            errorMessage += "Dictionary does not contain items key\n"
            return
        }
        for item in array {
            if let item = item as? JSONDictionary {
                
                let itemId: Int? = item["itemId"] as? Int
                let parentItemId: Int? = item["parentItemId"] as? Int
                let name: String? = item["name"] as? String
                let salePrice: Double? = item["salePrice"] as? Double
                let shortDescription: String? = (item["shortDescription"] as? String)?.htmlToString
                let thumbnailUrlString: String? = item["thumbnailImage"] as? String
                let product:Product = Product.init(itemId: itemId, parentItemId: parentItemId, name: name, salePrice: salePrice, shortDescription: shortDescription, thumbnailUrlString: thumbnailUrlString)
                isMappingTrendingResults ? trendingResults.append(product) : searchResults.append(product)
            } else {
                errorMessage += "Problem mapping search result dictionary\n"
            }
        }
    }
    
    
    fileprivate func mapRecommendationsResponse(_ data: Data) {
        var response: [JSONDictionary]?
        recommendationsResults.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [JSONDictionary]
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response else {
            errorMessage += "Dictionary is not an array"
            return
        }
        for item in array {
            if let item = item as? JSONDictionary {
                
                let itemId: Int? = item["itemId"] as? Int
                let parentItemId: Int? = item["parentItemId"] as? Int
                let name: String? = item["name"] as? String
                let salePrice: Double? = item["salePrice"] as? Double
                let shortDescription: String? = (item["shortDescription"] as? String)?.htmlToString
                let thumbnailUrlString: String? = item["thumbnailImage"] as? String
                let product:Product = Product.init(itemId: itemId, parentItemId: parentItemId, name: name, salePrice: salePrice, shortDescription: shortDescription, thumbnailUrlString: thumbnailUrlString)
                recommendationsResults.append(product)
            } else {
                errorMessage += "Problem mapping recommendationDictionary\n"
            }
        }
    }
    
    fileprivate func mapDetailsResponse(_ data: Data) {
        var response: JSONDictionary?
        searchResults.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }

        if let item = response {
            
            let itemId: Int? = item["itemId"] as? Int
            let parentItemId: Int? = item["parentItemId"] as? Int
            let name: String? = item["name"] as? String
            let salePrice: Double? = item["salePrice"] as? Double
            let shortDescription: String? = (item["shortDescription"] as? String)?.htmlToString
            let longDescription: String? = (item["longDescription"] as? String)?.htmlToString
            let brandName: String? = item["brandName"] as? String
            let thumbnailUrlString: String? = item["thumbnailImage"] as? String
            let mediumImageUrlString: String? = item["mediumImage"] as? String
            let largeImage: String? = item["largeImage"] as? String
            let standardShipRate: Float? = item["standardShipRate"] as? Float
            let size: String? = item["size"] as? String
            let color: String? = item["color"] as? String
            let marketPlace: Bool? = item["marketplace"] as? Bool
            let shipToStore: Bool? = item["shipToStore"] as? Bool
            let freeShipToStore: Bool? = item["freeShipToStore"] as? Bool
            let modelNumber: String? = item["modelNumber"] as? String
            let stock: String? = item["stock"] as? String
            let offerType: String? = item["offerType"] as? String
            let isTwoDayShippingAvailable: Bool? = item["isTwoDayShippingEligible"] as? Bool
            let availableOnline: Bool? = item["availableOnline"] as? Bool
            
            let productDetailsObject:ProductDetails = ProductDetails.init(itemId: itemId, parentItemId: parentItemId, name: name, salePrice: salePrice, shortDescription: shortDescription, longDescription: longDescription, brandName: brandName, thumbnailUrlString: thumbnailUrlString, mediumImageUrlString: mediumImageUrlString, largeImage: largeImage, standardShipRate: standardShipRate, size: size, color: color, marketPlace: marketPlace, shipToStore: shipToStore, freeShipToStore: freeShipToStore, modelNumber: modelNumber, stock: stock, offerType: offerType, isTwoDayShippingAvailable: isTwoDayShippingAvailable, availableOnline: availableOnline)
                                                                          
            productDetailsResults = productDetailsObject
        } else {
            errorMessage += "Problem mapping details dictionary\n"
        }
    }
    
}
