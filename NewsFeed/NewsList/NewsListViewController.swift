//
//  ViewController.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/3/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import UIKit
import RxSwift

final class NewsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource {
    var viewModel = NewsListViewModel()
    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.viewModelBinding(viewModel: viewModel)
        viewModel.getNews()
    }

    private func viewModelBinding(viewModel: NewsListViewModel) {
        viewModel.errorMessage.asObservable()
            .filter{$0 != nil}
            .subscribe(onNext: { [unowned self] errorMessage in
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }).addDisposableTo(disposeBag)

        viewModel.newsList.asObservable().subscribe(onNext: { [unowned self] _ in
            self.tableView.reloadData()
        }).addDisposableTo(disposeBag)

        viewModel.shouldShowLoading.asObservable().subscribe(onNext: { [unowned self] shouldAnimate in
            self.activityIndicator.superview?.isHidden = !shouldAnimate
            if shouldAnimate {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }).addDisposableTo(disposeBag)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NewsDetailsViewController") as? NewsDetailsViewController else { return }
        let presentationModel = viewModel.newsList.value[indexPath.row]
        viewController.viewModel = NewsDetailsViewModel(urlString: presentationModel.url)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension NewsListViewController {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinedArticleCollectionViewCell", for: indexPath)
        
        return cell
    }
}

extension NewsListViewController {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsList.value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        
        let presentationModel = viewModel.newsList.value[indexPath.row]
        cell.setupCellWith(presentationModel: presentationModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.newsList.value.count - 1 {
            viewModel.getNews()
        }
        
        print("real \(indexPath.row) - \(cell.frame.height)")
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let presentationModel = viewModel.newsList.value[indexPath.row]
        var totalHeight: CGFloat = 0
        let labelWidth = self.view.frame.width - 93
        let titleHeight = NSString(string: presentationModel.title).boundingRect(with: CGSize(width: Double(labelWidth), height: Double.greatestFiniteMagnitude),
                                                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                                 attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)],
                                                                                 context: nil).size.height
        totalHeight += titleHeight
        let tagHeight = presentationModel.attributedString?.boundingRect(with: CGSize(width: Double(labelWidth), height: Double.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size.height ?? 0
        
        totalHeight += tagHeight
        
        totalHeight += 93 // padding and margins
        
        print("esetimated \(indexPath.row) - \(totalHeight)")
        return totalHeight
    }
}
