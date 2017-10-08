//
//  NewsCell.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/4/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

final class NewsCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var attributedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        title.isOpaque = false
        attributedLabel.isOpaque = false
        dateLabel.isOpaque = false
        self.isOpaque = false
    }

    func setupCellWith(presentationModel: NewsListPresentationModel) {
        self.title.text = presentationModel.title
        self.dateLabel.text = presentationModel.dateString
        self.attributedLabel.attributedText = presentationModel.attributedString
        let url = URL(string: presentationModel.imageUrl)
        self.thumbnail.sd_setImageWithPreviousCachedImage(with: url, placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)
    }
}
