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
    let pages: Int
    let currentPage: Int
    
    let news: [NewsModel]

    enum CodingKeys: String, CodingKey {
        case news = "results"
        case status
        case total
        case startIndex
        case pages
        case currentPage
    }
}

struct NewsModel: Codable {
    let id: String
    let webTitle: String
    let webUrl: String
    let webPublicationDate: Date
    let fields: Fields?
}

struct Fields: Codable {
    let thumbnail: String
}
