//
//  NewsDetailsViewModel.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/5/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import Foundation

final class NewsDetailsViewModel {
    private let urlString: String
    private let id: String

    init(urlString: String, id: String) {
        self.urlString = urlString
        self.id = id
    }

    var request: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }

        return URLRequest(url: url, cachePolicy:  NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: TimeInterval(10))
    }
    
    func pinItem() {
        DataManager.savePinnedNews(id: id)
    }
}
