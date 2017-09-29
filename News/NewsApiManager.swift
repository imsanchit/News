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

final class NewsApiManager {
    static let sharedInstance = NewsApiManager()
    private init() {}

    func getResponse<T: Mappable>(url: URL, completion:@escaping(_ responseType: T?, _ error: Error?) -> Void) {
        Alamofire.request(url).responseObject(completionHandler: {(response:DataResponse<T>) -> Void in
            completion(response.result.value, response.error)
        })
    }
}
