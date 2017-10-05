//
//  NewsListParameter.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/4/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import Foundation

struct NewsListParameter: Router {
    let page: Int
    let pageSize: Int?

    var params: [String : Any] {
        var param = ["page": page]
        if let pageSize = pageSize {
            param["page-size"] = pageSize
        }
        
        return param
    }
    var path: String { return "search" }
    var httpMethod: HttpMethod { return .get }
}
