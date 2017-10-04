//
//  Router.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/4/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import Foundation

protocol Router {
    var params: [String: Any] { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
}

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}
