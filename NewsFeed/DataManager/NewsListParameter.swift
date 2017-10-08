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
    let pageSize: Int
    let fromDate: String?

    var params: [String : Any] {
        var param: [String : Any] = ["page": page]
        param["page-size"] = pageSize
        param["show-fields"] = "thumbnail"

        if let fromDate = fromDate {
            param["from-date"] = fromDate
        }
        
        return param
    }
    var path: String { return "search" }
    var httpMethod: HttpMethod { return .get }
}
