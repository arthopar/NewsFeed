//
//  ViewController.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/3/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController {
    var viewModel = NewsListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        viewModel.getNews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

