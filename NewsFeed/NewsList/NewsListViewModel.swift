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

final class NewsListViewModel {
    let newsList = Variable<[NewsListPresentationModel]>([])
    let errorMessage = Variable<String>("")
    let shouldShowLoading = Variable<Bool>(false)

    private var canLoadMore = true
    private var lastPage = 1

    func getNews() {
        guard canLoadMore else { return }

        self.shouldShowLoading.value = true
        let params = NewsListParameter(page: lastPage)
        DataManager.fetchNews(params: params) {[weak self] (newsListModel, error) in
            guard let _self = self else { return }

            _self.shouldShowLoading.value = false

            if newsListModel?.status != "ok" || error != nil {
                _self.errorMessage.value = error?.localizedDescription ?? "No data found"
            } else {
                _self.canLoadMore = _self.lastPage < newsListModel!.pages

                _self.processNews(newsListModel: newsListModel!)
            }
        }
    }

    private func processNews(newsListModel: NewsListModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        lastPage += 1
        let presentationModel = newsListModel.news.map ({ newsModel -> NewsListPresentationModel in
            let tags = newsModel.webTitle.split(separator: " ").map(String.init)
            let dateString = formatter.string(from: newsModel.webPublicationDate)
            return NewsListPresentationModel(dateString: dateString, image: nil, title: newsModel.webTitle, tags: tags)
        })

        newsList.value += presentationModel
    }
}
