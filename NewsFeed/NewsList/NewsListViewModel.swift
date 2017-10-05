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
    let attributedString: NSAttributedString?
    let url: String
}

final class NewsListViewModel {
    let newsList = Variable<[NewsListPresentationModel]>([])
    let errorMessage = Variable<String?>(nil)
    let shouldShowLoading = Variable<Bool>(false)

    private var canLoadMore = true
    private var lastPage = 1

    private let labelForSize = UILabel()
    private var timer: Timer?

    init() {
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }

    @objc func update() {
        getNews()
    }

    func getNews() {
        guard canLoadMore else { return }

        self.shouldShowLoading.value = true
        let params = NewsListParameter(page: lastPage, pageSize: nil)
        DataManager.fetchNews(params: params) {[weak self] (newsListModel, error) in
            guard let _self = self else { return }

            DispatchQueue.main.async { 
                _self.shouldShowLoading.value = false
            }

            if newsListModel?.status != "ok" || error != nil {
                DispatchQueue.main.async {
                   _self.errorMessage.value = error?.localizedDescription ?? "No data found"
                }
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
            return NewsListPresentationModel(dateString: dateString, image: nil, title: newsModel.webTitle, tags: tags, attributedString: setupAttributedStrings(tags: tags), url:newsModel.webUrl)
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
        labelForSize.text = " \(withString) "
        labelForSize.sizeToFit()

        let renderer = UIGraphicsImageRenderer(size: labelForSize.bounds.size)
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
