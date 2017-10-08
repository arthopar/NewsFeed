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

struct PinnedItem {
    let id: String
    let label: String
}
struct NewsListPresentationModel {
    let id: String
    let dateString: String
    let imageUrl: String
    let title: String
    let tags: [String]
    let attributedString: NSAttributedString?
    let url: String
}

final class NewsListViewModel {
    let newsList = Variable<[NewsListPresentationModel]>([])
    let errorMessage = Variable<Error?>(nil)
    let shouldShowLoading = Variable<Bool>(false)
    var pinnedArticles = [String]()
    var newsIds = [String]()
    var pinnedItems = [PinnedItem]()

    private var canLoadMore = true
    private var lastPage: Int { return newsList.value.count / pageSize + 1 }
    private var pageSize = 10

    private var timer: Timer?

    init() {
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }

    @objc func update() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date())
        let params = NewsListParameter(page: 1, pageSize: pageSize, fromDate: dateString)
        getNewsWith(params: params)
    }

    func getCachedNews() {
        guard canLoadMore else { return }

        let data = DataManager.getCachedNews(fetchLimit: pageSize, fetchOffset: lastPage)
        if data.count == 0 {
            canLoadMore = false
            return
        }
        processNews(newsListModel: data)
    }

    func getNews() {
        let params = NewsListParameter(page: lastPage, pageSize: pageSize, fromDate: nil)
        getNewsWith(params: params)
    }
    
    private func getNewsWith(params: NewsListParameter) {
        guard canLoadMore || params.fromDate != nil else { return }
        
        self.shouldShowLoading.value = true
        
        print("params = \(params)")
        DataManager.fetchNews(params: params) {[weak self] (newsListModel, error) in
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                _self.shouldShowLoading.value = false
            }
            
            if newsListModel?.status != "ok" || error != nil {
                DispatchQueue.main.async {
                    _self.errorMessage.value = error
                }
            } else {
                guard let newsListModel = newsListModel else {
                    _self.processNews(newsListModel: [])
                    
                    return
                }
                var news = newsListModel.news

                if params.fromDate != nil {
                    news = news.filter { !_self.newsIds.contains($0.id) }
                } else {
                    _self.canLoadMore = _self.lastPage < newsListModel.pages
                }
                _self.processNews(newsListModel: news)
            }
        }
    }

    private func processNews(newsListModel: [NewsModel]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let pinnedItems = DataManager.getPinnedNews()
        let presentationModel = newsListModel.map ({ newsModel -> NewsListPresentationModel in
            let tags = newsModel.webTitle.split(separator: " ").map(String.init)
            let dateString = formatter.string(from: newsModel.webPublicationDate)
            self.newsIds.append(newsModel.id)
            let isPinned = pinnedItems.contains(newsModel.id)
            if isPinned {
                self.pinnedItems.append(PinnedItem(id: newsModel.id, label: newsModel.webTitle))
            }
            
            return NewsListPresentationModel(id: newsModel.id, dateString: dateString, imageUrl: newsModel.fields?.thumbnail ?? "", title: newsModel.webTitle, tags: tags, attributedString: setupAttributedStrings(tags: tags), url:newsModel.webUrl)
        })

        DispatchQueue.main.async {[unowned self] in
            self.newsList.value += presentationModel
        }
    }

    func setupAttributedStrings(tags: [String]) -> NSMutableAttributedString {
        let mutableAttrebutedText = NSMutableAttributedString()
        for i in 0..<tags.count {
            mutableAttrebutedText.append(NSAttributedString(string: " "))
            mutableAttrebutedText.append(labelsString(tags[i]))
            mutableAttrebutedText.append(NSAttributedString(string: " "))
        }

        return mutableAttrebutedText
    }

    func labelsString(_ withString: String) -> NSAttributedString {
        let size = " \(withString) ".boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude),
                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                    attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)],
                                                    context: nil).size
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.darkGray.setFill()
            var frame = renderer.format.bounds
            let path = UIBezierPath(roundedRect: frame, cornerRadius: 6)
            path.fill()

            let attrs: [NSAttributedStringKey : Any] = [.foregroundColor: UIColor.white]

            frame.origin.x += 2
            frame.origin.y += 2
            frame.size.width -= 4
            frame.size.height -= 4
            let attributedString = NSAttributedString(string: " \(withString) ", attributes: attrs)
            attributedString.draw(in: frame)
        }

        let attributedStringTextAttachment = NSTextAttachment()
        attributedStringTextAttachment.image = image
        return NSAttributedString(attachment: attributedStringTextAttachment)
    }
}
