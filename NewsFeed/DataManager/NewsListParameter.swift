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
    var params: [String : Any] {
        return ["page": page]
    }
    var path: String { return "search" }
    var httpMethod: HttpMethod { return .get }
}
