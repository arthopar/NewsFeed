//
//  NewsListViewModel.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/3/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

struct NewsListPresentationModel {
    let dateString: String
    let image: UIImage?
    let title: String
    let tags: [String]
}

class NewsListViewModel {
    let newsList = Variable<[NewsListPresentationModel]>([])
    var lastPage = 1

    func getNews() {
        
        let params = NewsListParameter(page: lastPage)
        DataManager.fetchNews(params: params) {[weak self] (newsListModel, error) in
            guard let _self = self else { return }

            if newsListModel?.status != "ok" || error != nil {
                //show error
            } else {
                _self.processNews(newsListModel: newsListModel!)
            }
        }
    }

    private func processNews(newsListModel: NewsListModel) {
        //let formatter = DateFormatter
        lastPage += 1
        let presentationModel = newsListModel.news.map ({ newsModel -> NewsListPresentationModel in
            let tags = newsModel.webTitle.split(separator: " ").map(String.init)
            return NewsListPresentationModel(dateString: newsModel.webPublicationDate, image: nil, title: newsModel.webTitle, tags: tags)
        })

        newsList.value = presentationModel
    }
}
