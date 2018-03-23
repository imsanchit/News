//
//  Sources.swift
//  News
//
//  Created by Sanchit Mittal on 15/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import Foundation
import ObjectMapper

class SourcesResponse: Mappable {
    var status: String?
    var sources: [Source]?
    
    required init?(map: Map){    
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        sources <- map["sources"]
    }
}
