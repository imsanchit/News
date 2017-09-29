//
//  Article.swift
//  News
//
//  Created by Sanchit Mittal on 19/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import Foundation
import ObjectMapper

class Article: Mappable {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        author <- map["author"]
        title <- map["title"]
        description <- map["description"]
        url <- map["url"]
        urlToImage <- map["urlToImage"]
        publishedAt <- map["publishedAt"]
    }
}

//struct Article {
//    var author : String?
//    var title : String?
//    var description : String?
//    var url : String?
//    var urlToImage : String?
//    var publishedAt : String?
//    
//    enum SerializationError: Error {
//        case invalid(String)
//    }
//
//    
//    init(json: [String:Any]) {
//        author = checkValidString(json, "author")
//        title = checkValidString(json, "title")
//        description = checkValidString(json, "description")
//        url = checkValidString(json, "url")
//        urlToImage = checkValidString(json, "urlToImage")
//        publishedAt = checkValidString(json, "publishedAt")
//    }
//    
//    private func checkValidString(_ json: [String:Any], _ key: String) ->String {
//        guard let value = json[key] as? String else {
//            return ""
//        }
//        return value
//    }
//

    
    
//    init(json: [String:Any]) throws {
//        do {
//            try author = checkValidString(json, "author")
//            try title = checkValidString(json, "title")
//            try description = checkValidString(json, "description")
//            try url = checkValidString(json, "url")
//            try urlToImage = checkValidString(json, "urlToImage")
//            try publishedAt = checkValidString(json, "publishedAt")
//        }
//        catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    private func checkValidString(_ json: [String:Any], _ key: String) throws ->String {
//        guard let value = json[key] as? String else {
//            throw SerializationError.invalid(key+" type invalid")
//        }
//        return value
//    }
//}
