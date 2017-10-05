//
//  NewsDetailsViewModel.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/5/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import Foundation

final class NewsDetailsViewModel {
    let urlString: String
    
    var request: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }

        return URLRequest(url: url)
    }
    init(urlString: String) {
        self.urlString = urlString
    }
}
