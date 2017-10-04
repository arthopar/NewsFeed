//
//  NewsListModel.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/4/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import Foundation

struct NewsListModel: Codable {
    let status: String
    let total: Int
    let startIndex: Int
    let pageSize: Int
    let currentPage: Int
    
    let news: [News]
}

struct News: Codable {
    let webTitle: String
    let webUrl: String
    let webPublicationDate: Date
}
