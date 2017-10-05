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
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!

    var tagLabels = [UILabel]()

    override func awakeFromNib() {
        super.awakeFromNib()

        title.isOpaque = false
        stackView.isOpaque = false
        dateLabel.isOpaque = false
        self.isOpaque = false

        setupTagView1()
    }

    func setupTagView(tags: [String]) {
        for i in 0..<tags.count {
            tagLabels[i].text = tags[i]
        }
    }

    func setupTagView1() {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        for tag in 0..<20 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.layer.cornerRadius = 5
            label.backgroundColor = UIColor.gray
            label.clipsToBounds = true
            label.isOpaque = false
            tagLabels.append(label)
            stack.addArrangedSubview(label)
            if stack.arrangedSubviews.count == 3 {
                stack.addArrangedSubview(UIView())
                self.stackView.addArrangedSubview(stack)
                stack = UIStackView()
                stack.translatesAutoresizingMaskIntoConstraints = false
                stack.axis = .horizontal
                stack.spacing = 5
                stack.alignment = .fill
                stack.distribution = .fillProportionally
                stack.isOpaque = false
            }
        }

        self.stackView.spacing = 5
    }

    func setupCellWith(presentationModel: NewsListPresentationModel) {
        self.title.text = presentationModel.title
        self.dateLabel.text = presentationModel.dateString
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.tagLabels.forEach{$0.text = ""}
    }
}
