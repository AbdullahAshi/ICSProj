//
//  ViewController.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import UIKit

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private enum CellType {
        case storyBoard
        case programmatically
    }
    
    private let viewModel = NewsFeedViewModel()
    private var articles: [Article] = []
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    private let cellType: CellType = .storyBoard
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cellType == .storyBoard {
            let nib = UINib(nibName: NewsFeedTableViewCell.identifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: NewsFeedTableViewCell.identifier)
        } else {
            tableView.register(NewsFeedTableViewCellProg.self, forCellReuseIdentifier: NewsFeedTableViewCellProg.identifier)
        }
        
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
        let cell: NewsFeedTableViewCellProtocol?
        
        if cellType == .storyBoard {
            cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableViewCell.identifier, for: indexPath) as? NewsFeedTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableViewCellProg.identifier, for: indexPath) as? NewsFeedTableViewCellProg
        }
        
        guard let cell = cell else {
            return UITableViewCell()
        }
        
        
        let article = articles[indexPath.row]
        if let url = article.urlToImage,
           !url.isEmpty {
            cell.configure(title: article.title, sourceName: article.source.name, url: URL(string: url))
        } else {
            cell.configure(title: article.title, sourceName: article.source.name, url: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
