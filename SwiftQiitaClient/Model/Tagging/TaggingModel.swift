//
//  TaggingModel.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/11/29.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct TaggingModel: Mappable {
    
    var name: String?
    var versions: [String]?
    
    init?(_ map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        versions <- map["versions"]
    }
    
}