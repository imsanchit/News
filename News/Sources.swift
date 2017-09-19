//
//  Sources.swift
//  News
//
//  Created by Sanchit Mittal on 15/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import Foundation

//name desc url
//popover : category(dropdown) country(dropdown) language
//for next sourceid sortBy

struct Sources {
    var id : String?
    var name : String?
    var description : String?
    var url : String?
    var category : String?
    var language : String?
    var country : String?
    var urlsToLogos : [String:String]?
    var sortBysAvailable : [String]?

    enum SerializationError: Error {
        case invalid(String)
    }

    init(json: [String:Any]) throws {
        do {
            try id = checkValidString(json, "id")
//            print(id!)
            try name = checkValidString(json, "name")
            try description = checkValidString(json, "description")
            try url = checkValidString(json, "url")
            try category = checkValidString(json, "category")
            try language = checkValidString(json, "language")
            try country = checkValidString(json, "country")
            try urlsToLogos = checkValidDictionary(json, "urlsToLogos")
//            print((urlsToLogos?["large"])!)
            try sortBysAvailable = checkValidArray(json, "sortBysAvailable")
//            for sortOrder in sortBysAvailable! {
//                print(sortOrder)
//            }
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
    private func checkValidDictionary(_ json: [String:Any], _ key: String) throws ->[String:String] {
        guard let value = json[key] as? [String: String] else {
            throw SerializationError.invalid(key+" type invalid")
        }
        return value
    }
    private func checkValidArray(_ json: [String:Any], _ key: String) throws ->[String] {
        guard let value = json[key] as? [String] else {
            throw SerializationError.invalid(key+" type invalid")
        }
        return value
    }
}
