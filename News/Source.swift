//
//  Source.swift
//  News
//
//  Created by Sanchit Mittal on 28/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import Foundation
import ObjectMapper

class Source: Mappable {
    var id: String?
    var name: String?
    var description: String?
    var url: String?
    var category: String?
    var language: String?
    var country: String?
    var urlsToLogos: [String]?
    var sortBysAvailable: [String]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        url <- map["url"]
        category <- map["category"]
        language <- map["language"]
        country <- map["country"]
        urlsToLogos <- map["urlsToLogos"]
        sortBysAvailable <- map["sortBysAvailable"]
    }
}
