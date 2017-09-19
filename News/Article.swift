//
//  Article.swift
//  News
//
//  Created by Sanchit Mittal on 19/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import Foundation
struct Article {
    var author : String?
    var title : String?
    var description : String?
    var url : String?
    var urlToImage : String?
    var publishedAt : String?
    
    enum SerializationError: Error {
        case invalid(String)
    }
    
    init(json: [String:Any]) throws {
        do {
            try author = checkValidString(json, "author")
            //            print(id!)
            try title = checkValidString(json, "title")
            try description = checkValidString(json, "description")
            try url = checkValidString(json, "url")
            try urlToImage = checkValidString(json, "urlToImage")
            try publishedAt = checkValidString(json, "publishedAt")
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    private func checkValidString(_ json: [String:Any], _ key: String) throws ->String {
        guard let value = json[key] as? String else {
            throw SerializationError.invalid(key+" type invalid")
        }
        return value
    }
}
