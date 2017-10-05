//
//  NewsCell.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/4/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import Foundation
import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var attributedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

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
    }
}
