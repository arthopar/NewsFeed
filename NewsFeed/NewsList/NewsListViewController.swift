//
//  ViewController.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/3/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import UIKit
import RxSwift

class NewsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var viewModel = NewsListViewModel()
    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.tableView.estimatedRowHeight = 122
        self.tableView.rowHeight = UITableViewAutomaticDimension

        viewModel.newsList.asObservable().subscribe(onNext: { [unowned self] _ in
            self.tableView.reloadData()
        }).addDisposableTo(disposeBag)
        viewModel.getNews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsList.value.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        let presentationModel = viewModel.newsList.value[indexPath.row]
        cell.stackView.arrangedSubviews.forEach{$0.removeFromSuperview()}
        
        var stack = UIStackView()
        stack.axis = .horizontal
        presentationModel.tags.forEach { tag in
            let label = UILabel()
            label.layer.cornerRadius = 5
            label.backgroundColor = UIColor.gray
            label.text = tag
            label.clipsToBounds = true
            stack.addArrangedSubview(label)
            if stack.arrangedSubviews.count == 3 {
                cell.stackView.addArrangedSubview(stack)
                stack = UIStackView()
                stack.axis = .horizontal
                stack.spacing = 5
                stack.alignment = .fill
                stack.distribution = .fillProportionally
            }
        }
        cell.stackView.spacing = 5
        cell.title.text = presentationModel.title
        cell.dateLabel.text = presentationModel.dateString

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.newsList.value.count - 1 { //you might decide to load sooner than -1 I guess...
            viewModel.getNews()
        }
    }
}

