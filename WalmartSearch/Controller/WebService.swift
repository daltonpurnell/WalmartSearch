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
    typealias SearchResult = ([Product]?, String) -> ()
    typealias RecommendationsResult = ([Product]?, String) -> ()
    typealias ProductDetailsResult = (ProductDetails?, String) -> ()
    
    var searchResults:[Product] = []
    var recommendationsResults:[Product] = []
    var productDetailsResults:ProductDetails?
    var errorMessage = ""
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getSearchResults(searchTerm: String, completion: @escaping SearchResult) {
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
                    self.mapSearchResponse(data)
                    DispatchQueue.main.async {
                        completion(self.searchResults, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func getRecommendations(itemId: Int, completion: @escaping RecommendationsResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: Constants.Urls.baseUrl) {
            urlComponents.path = Constants.Paths.recommendationsPath
            urlComponents.query = "apiKey=\(Constants.Keys.walmartOpenApiKey)itemId=\(itemId)&order=asc"
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
    
    func getProductDetails(itemId: Int, completion: @escaping ProductDetailsResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: Constants.Urls.baseUrl) {
            urlComponents.path = "\(Constants.Paths.recommendationsPath)/\(itemId)"
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
    
    fileprivate func mapSearchResponse(_ data: Data) {
        var response: JSONDictionary?
        searchResults.removeAll()
        
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
                let salePrice: Float? = item["salePrice"] as? Float
                let shortDescription: String? = item["shortDescription"] as? String
                let thumbnailUrlString: String? = item["thumbnailString"] as? String
                let product:Product = Product.init(itemId: itemId, parentItemId: parentItemId, name: name, salePrice: salePrice, shortDescription: shortDescription, thumbnailUrlString: thumbnailUrlString)
                searchResults.append(product)
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
                let salePrice: Float? = item["salePrice"] as? Float
                let shortDescription: String? = item["shortDescription"] as? String
                let thumbnailUrlString: String? = item["thumbnailString"] as? String
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
            let salePrice: Float? = item["salePrice"] as? Float
            let shortDescription: String? = item["shortDescription"] as? String
            let longDescription: String? = item["longDescription"] as? String
            let thumbnailUrlString: String? = item["thumbnailString"] as? String
            let productDetailsObject:ProductDetails = ProductDetails.init(itemId: itemId, parentItemId: parentItemId, name: name, salePrice: salePrice, shortDescription: shortDescription, longDescription: longDescription, thumbnailUrlString: thumbnailUrlString)
            productDetailsResults = productDetailsObject
        } else {
            errorMessage += "Problem mapping details dictionary\n"
        }
    }
    
}
