//
//  ArticlesResponse.swift
//  News
//
//  Created by Sanchit Mittal on 29/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import Foundation
import ObjectMapper

class ArticlesResponse: Mappable {
 
    var status: String?
    var source: String?
    var sortBy: String?
    var articles: [Article]?
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        status <- map["status"]
        source <- map["source"]
        sortBy <- map["sortBy"]
        articles <- map["articles"]
    }
}
