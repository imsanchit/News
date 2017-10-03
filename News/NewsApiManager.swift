//
//  NewsApiManager.swift
//  News
//
//  Created by Sanchit Mittal on 29/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

// only contain object for responseType as Response data
final class NewsApiManager {
    static let sharedInstance = NewsApiManager()
    private init() {}
    let baseURL: String = "https://newsapi.org/v1/"
    
    
    public func getSources(categoryFilter: CategoryFilters , countryFilter: CountryFilters, showResponse: @escaping(_ sourcesResponse:SourcesResponse?) -> Void, showError: @escaping() -> Void ) {
        let path = baseURL + "sources"
        let url = URL(string: path)
        let method: HTTPMethod = .get
        var parameters: [String: Any] = [:]
        parameters["language"] = "en"
        parameters["category"] = categoryFilter == .all ? "" : categoryFilter.description()
        parameters["country"] = countryFilter == .all ? "" : countryFilter.description()
        let encoding: URLEncoding = URLEncoding.default
        let headers: HTTPHeaders = [:]

        getResponse(url: url!, method: method, parameters: parameters, encoding: encoding, headers: headers, completion: { (_ responseType: SourcesResponse?, _ error: Error?) -> Void in
            if error != nil {
                showError()
                return
            }
            showResponse(responseType)
            })
    }

    public func getArticles(selectedSortByFilter: SortByFilter, sourceID: String, showResponse: @escaping(_ articlesResponse:ArticlesResponse?) -> Void, showError: @escaping() -> Void ) {
        let path = baseURL + "articles"
        let url = URL(string: path)
        let method: HTTPMethod = .get
        var parameters: [String: Any] = [:]
        parameters["source"] = sourceID
        parameters["apiKey"] = "ef9ea2e569c249a29291c7b410e63794"
        parameters["sortBy"] = selectedSortByFilter.description()
        let encoding: URLEncoding = URLEncoding.default
        let headers: HTTPHeaders = [:]
        
        getResponse(url: url!, method: method, parameters: parameters, encoding: encoding, headers: headers, completion: { (_ responseType: ArticlesResponse?, _ error: Error?) -> Void in
            if error != nil {
                showError()
                return
            }
            showResponse(responseType)
        })
    }
    
    
    private func getResponse<T: Mappable>(url: URL,method: HTTPMethod, parameters: [String: Any], encoding: URLEncoding, headers: HTTPHeaders, completion:@escaping(_ responseType: T?, _ error: Error?) -> Void) {
        Alamofire.request(url,method: .get, parameters: parameters, encoding: encoding, headers: headers).responseObject(completionHandler: {(response:DataResponse<T>) -> Void in
            completion(response.result.value, response.error)
        })
    }
}
