//
//  NewsDetailsViewController.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/5/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import Foundation
import UIKit
import WebKit

final class NewsDetailsViewController: UIViewController {
    var viewModel: NewsDetailsViewModel?
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let request = viewModel?.request {
            webView.load(request)
        }
    }
}
