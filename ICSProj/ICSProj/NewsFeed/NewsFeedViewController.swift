//
//  ViewController.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import UIKit

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel = NewsFeedViewModel()
    private var articles: [Article] = []
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let nib = UINib(nibName: NewsFeedTableViewCellProg.identifier, bundle: nil)
        //tableView.register(nib, forCellReuseIdentifier: NewsFeedTableViewCellProg.identifier)
        
        tableView.register(NewsFeedTableViewCellProg.self, forCellReuseIdentifier: NewsFeedTableViewCellProg.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        // Setup activity indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Setup refresh control
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        fetchArticles()
    }
    
    @objc private func refreshPulled() {
        fetchArticles()
    }
    
    private func fetchArticles() {
        activityIndicator.startAnimating()
        viewModel.getArticles { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.tableView.reloadData()
                case .failure:
                    self?.articles = []
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableViewCellProg.identifier, for: indexPath) as? NewsFeedTableViewCellProg else {
            return UITableViewCell()
        }
        let article = articles[indexPath.row]
        cell.configure(title: article.title, sourceName: article.source.name, url: article.urlToImage != nil ? URL(string: article.urlToImage!) : nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
